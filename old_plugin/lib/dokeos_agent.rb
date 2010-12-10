require 'ruby-debug'

class DokeosAgent 
  
  attr_accessor :login
  attr_accessor :password
  attr_accessor :url
  attr_accessor :agent
  
  def crawl_sessions(h={})
    h[:reload] = {} unless h[:reload]
    reload=h[:reload][:sessions]
    
    crawl_trainings h
    
    if reload or TrainingSession.find_all.length == 0
      
      pagenum=-1
      num_found = 0
      do_crawl = true
      
      while do_crawl
        pagenum += 1
        do_crawl = false
        if page = get_page(:page => "main/admin/session_list.php?page=#{pagenum}")
          page.links.each do |link|
            if matchdata = link.uri.to_s.match(/resume_session.php.+?(\d+)/)
              do_crawl = true unless do_crawl
              training_session = nil
              debugger
              begin
                if training_session = TrainingSession.find_only_one(:all, {:conditions => {:training_session_name => link.text}}) 
                else
                  training_session = TrainingSession.create(:training_session_name => link.text,
                                                            :dokeos_id => matchdata[1])
                end
                ckebug 0, "creating TrainingSession record for #{link.text}#{matchdata[1]}"
              rescue Exception => e
                ckebug 0, "warning: #{e}"
              end
              raise "no training_session" unless training_session
              crawl_session(:url => "main/admin/#{link.uri.to_s}")
              
            end
          end
        end
      end
    end
  end
  
  def crawl_session_results(h={})
    crawl_session(h)
    id = h[:id]
    start_with = h[:start_with]
    only = h[:only]
    
    started = start_with ? false : true
    
    session = TrainingSession.find_by_dokeos_id(id)
    
    session.training_session_users.each do |user|
      started = true if user.dokeos_user.dokeos_id.to_i == start_with.to_i
      next unless started
      next if only and user.dokeos_user.dokeos_id.to_i != only.to_i
      crawl_user(:id => user.dokeos_user.dokeos_id,
                 :session_id => id)
    end
  end
  
  
  ################################################################################
  
  def crawl_session(h={})
    url = h[:url]
    id = h[:id]
    
#    debugger
    url = "main/admin/resume_session?id_session=#{id}" if id
    
    unless id 
      id = (_tmp = url.match(/(\d+)/)) ? _tmp[1] : nil
    end
    
    training_session = nil
    
    if session_page = get_page(:page => url)
      if data_tables = session_page.search(".//table[@class='data_table']")
        # create or find training_session row
        
        session_name = data_tables[0].search("td")[1].text
        
        training_session = find_or_create(:klass => TrainingSession,
                                          :conditions => {
                                            :training_session_name => session_name,
                                            :dokeos_id => id
                                          },
                                          :required => true)
        
        
        # GET TRAININGS LIST
        if trainings_list = data_tables[1]
          if data_table_rows = trainings_list.search("tr")
            first_row = 3
            while training_row =  data_table_rows[first_row]
              if training_cells = training_row.search("td")
                if training = training_cells[0]
                  matchdata = training.text.match(/(.+) \((.+)\)/)
                  
                  training_code = matchdata[2]
                  training_name = matchdata[1]
                  
                  raise "cannot find training #{training_name}" unless 
                    t = Training.find_only_one(:all, :conditions => {
                                                 :training_name => training_name
                                               })
                  
                  find_or_create(:klass => TrainingSessionAssoc,
                                 :conditions => {:training_id => t.id,
                                   :training_session_id => training_session.id},
                                 :require => true)
                  
                end
              end
              first_row += 1
            end
          end
        end
        
        # GET USERS LIST
        
        if data = data_tables[2]
          if data_table_rows = data.search("tr")
            first_row = 1
            
            while data_row =  data_table_rows[first_row]
              login_name, dokeos_user = nil
              
              if data_cells = data_row.search("td")
                (cell1,cell2) = data_cells
                if namecell = cell1.search("b")
                  if matchdata = namecell.text.match(/\((.+)\)/)
                    login_name = matchdata[1]
                  end
                end
                if data = cell2.search("a")
                  if firstlink = data[0]
                    if href = firstlink.get_attribute("href")
                      if matchdata = href.match(/student=(\d+)/)
                        student_id = matchdata[1]
                        dokeos_user = find_or_create(:klass => ::DokeosUser, 
                                                     :conditions => {:dokeos_id => student_id,
                                                       :dokeos_user_name => login_name},
                                                     :required => true)
                        
                        find_or_create(:klass => TrainingSessionUser,
                                       :conditions => {:training_session_id => training_session.id,
                                         :dokeos_user_id => dokeos_user.id})
                      end
                    end
                  end
                end
              end
              first_row += 1
            end
          end
        end
      end
    end
  end

#   def crawl_user_results(h={})
#     session_id=h[:session_id] or raise "set :session_id"
#     id = h[:id] or raise "set :id"
    
#   end
    

  def crawl_user(h={})
    id = h[:id]
    if session_id=h[:session_id]
      raise "no such training_session #{session_id}" unless master_training_session = TrainingSession.find_by_dokeos_id(session_id)
    end
    
    details_page = get_page("main/admin/user_edit.php?user_id=#{id}")
    
    dokeos_user = nil
    
    if inputs = details_page.search(".//form/div/div/input")
      last_name = inputs[0].get_attribute("value")
      first_name = inputs[1].get_attribute("value")
      code = inputs[2].get_attribute("value")
      email = inputs[3].get_attribute("value")
      
      login_name = inputs[6].get_attribute("value")
      if login_name == "1" # means they uploaded a profile image
        login_name = inputs[7].get_attribute("value")
      end
      
      dokeos_user = find_or_create(:klass => DokeosUser,
                                   :conditions => {
                                     :dokeos_user_name => login_name,
                                     :dokeos_id => id.to_i
                                   },
                                   :required => true)
      
      dokeos_user.first_name = first_name
      dokeos_user.last_name = last_name
      dokeos_user.code = code
      dokeos_user.email = email
      dokeos_user.save
    end
    
    user_page = get_page(:page => "main/mySpace/myStudents.php?student=#{id}")
    
    
    if table_rows = (datatables = user_page.search(".//table[@class='data_table']")) ? datatables[2].search("tr") : nil
      first_row = 2
      while row = table_rows[first_row]
        first_row += 1
        
        training_name = row.search("td")[0].text.gsub(/[\r\t\n]/,'')
        
        if training = Training.find_only_one(:all, :conditions => {:training_name => training_name})
          
          if score_page = get_page("main/mySpace/myStudents.php?student=#{id}&details=true&course=#{training.training_code}&origin=&id_session=#{session_id}#infosStudent")


            # are we using a training session via the command line?  If not, look for a textual description
            unless master_training_session
              session_name = score_page.search(".//strong").text.split(/\|/).last.gsub(/ Session : /,'')
            
              if session_name and session_name.length > 0
                local_training_session = TrainingSession.find_by_training_session_name(session_name)
              end
            end

            courses = score_page.search(".//table[@class='data_table']")[3]              
            tests = score_page.search(".//table[@class='data_table']")[4]
            
            test_rows=tests.search("tr")
            
            row_number=1
            
            while row_number < test_rows.length
              row = test_rows[row_number]
              
              row_number += 1
              
              tds = row.search("td")
              
              next if tds.length < 3
              
              course = tds[0].text.gsub(/[\t\r\n]/,'')
              score = tds[1].text.gsub(/[\t\r\n]/,'')
              attempts = tds[2].text.gsub(/[\t\r\n]/,'')
              
              training_course = find_or_create(:klass => TrainingCourse, 
                                               :conditions => {
                                                 :training_id => training.id,
                                                 :training_course_name => course,
                                                 :course_type => 'test'
                                               },
                                               :required => true)
              
              training_course_result = find_or_create(:klass => TrainingCourseResult,
                                                      :conditions => {
                                                        :training_course_id => training_course.id,
                                                        :dokeos_user_id => dokeos_user.id,
                                                        :training_session_id => (master_training_session || local_training_session).send(:id)
                                                      },
                                                      :required => true)
              
              
              training_course_result.score = convert_score(score)
              training_course_result.attempts = attempts
              
              training_course_result.save
            end
            
            course_rows = courses.search("tr")
            row_number = 1
            while row_number < course_rows.length
              row = course_rows[row_number]
              row_number += 1
              tds = row.search("td")
              
              next if tds.length < 4
              
              course = tds[0].text.gsub(/[\t\r\n]/,'')
              time = tds[1].text.gsub(/[\t\r\n]/,'')
              score = tds[2].text.gsub(/[\t\r\n]/,'')
              progress = tds[3].text.gsub(/[\t\r\n]/,'')
              
              training_course = find_or_create(:klass => TrainingCourse, 
                                               :conditions => {
                                                 :training_id => training.id,
                                                 :training_course_name => course,
                                                 :course_type => 'course'
                                               },
                                               :required => true)
              
              training_course_result = find_or_create(:klass => TrainingCourseResult,
                                                      :conditions => {
                                                        :training_course_id => training_course.id,
                                                        :dokeos_user_id => dokeos_user.id,
                                                        :training_session_id => (master_training_session || local_training_session).send(:id)                                                        
                                                      },
                                                      :required => true)
              
              training_course_result.progress = progress.gsub(/%/,'')
              training_course_result.score = convert_score(score)
              
              training_course_result.total_time = convert_time(time)
              
              training_course_result.save
              
            end
            
          end
        end
        
      end
    end
  end
  
  def convert_score(score)
    unless matchdata = score.match(/[0-9]/)
      nil
    else
      ckebug 0, "converting #{score}"
      score.gsub(/[ %]/,'')
    end
  end
  
  def convert_time(time)
    if matchdata = time.match(/(\d+):(\d+):(\d+)/)
      matchdata[1].to_i * 3600 + matchdata[2].to_i * 60 + matchdata[3].to_i
    else
      nil
    end
  end
  
  ################################################################################

  def method_missing(sym, *args, &block)
    agent.send(sym,*args,&block)
  end
  
  ################################################################################

  def initialize(h={})
    
    h.keys.each do |k|
      self.send("#{k}=",h[k])
    end
    
    yield self if block_given?
    
    @agent = Mechanize.new
    ckebug 0, h.inspect
    
    raise "set :login, :password, and :url" unless login and password and url
    
    login_page = get("#{url}/index.php")
    loginForm = login_page.form('formLogin')
    
    loginForm.login = "bret.weinraub"
    loginForm.password = "minimedVENDOR09"
    
    logged_in_page = submit(loginForm,loginForm.button('submitAuth'))

    
    get_page(:page => "main/admin/session_list.php")
    
    #     logged_in_page.links.each do |link|
    #       ckebug 0, "found #{link.text}"
    #     end
  end
  
  ################################################################################

  def get_page(h={})
    if h.is_a? Hash
      raise "set :page in #{current_method}" unless page = h[:page]
    else
      page = h
    end
    
    url = "#{url}/#{page}"
    fetched = msg_exec "fetching page #{url}"  do
      get(url)
    end
#       fetched.links.each do |link|
#         ckebug 1, "#{url}: (#{link.text}): #{link.uri.to_s}"
#       end
    fetched
  end
  
  ################################################################################
  
  ################################################################################

  def find_or_create(h={})
    klass = h[:klass] or raise "set :klass"
    conditions = h[:conditions] or raise "set :conditions"
    require = h[:require] || h[:required]

    e = ret = nil
    if ret = klass.find_only_one(:all, :conditions => conditions)
      ckebug 0, "found #{klass} record : #{conditions.inspect}"
    else
      begin
        ret = klass.create(conditions)
        ckebug 0, "created #{klass} record : #{conditions.inspect}"
      rescue Exception => e
      end
    end
    if ret.nil? and require
      raise "failed to create a #{klass} record for #{conditions.inspect}#{e ? ': ' + e : nil}"
    end
    ret
  end
    
  ################################################################################

  ################################################################################

  def crawl_trainings(h={})
    h[:reload] = {} unless h[:reload]
    reload=h[:reload]

    max_page = 20 # XXXXX - 
    if reload or Training.find_all.length == 0
      
      pagenum=0
      num_found = 0
      do_crawl = true
      
      while do_crawl
        pagenum += 1
        if pagenum >= max_page
          ckebug 0, "XXXXXXXXXXXXXX!!!!!!!!!! - BUG; Hit hard limit on page #s in #{current_method}"
          break
        end
        do_crawl = false
        if page = get_page(:page => "main/admin/course_list.php?courses_page_nr=#{pagenum}")
          if data_table = page.search(".//table[@class='data_table']/tr")
            data_table.each do |row|
              results = {}
              num_created = 0
              if row.class == Nokogiri::XML::Element
                if cells = row.search("td")
                  (firstcell,secondcell,thirdcell,forthcell,fifthcell) = cells
                  menu = cells[9]
                  if firstcell and input = firstcell.search("input")
                    results[:training_code] = input.attr("value").value
                  end
                  results[:training_name] = thirdcell.text if thirdcell
                  results[:lang] = forthcell.text if forthcell
                  if results.keys.length > 0
                    find_or_create(:klass => Training, 
                                   :conditions => results,
                                   :required => true)
                    num_created += 1
                  end
                end
              end
              do_crawl = true if num_created > 0
            end
          end
        end
      end
    end
    
  end
end
