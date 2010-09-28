class DokeosAgent 

  [:sessions,:users].each do |inc|
    require File.join(File.dirname(__FILE__),"#{inc}.rb")
  end


  include ::DokeosRobot::Sessions
  include ::DokeosRobot::Users
  
  attr_accessor :login
  attr_accessor :password
  attr_accessor :url
  attr_accessor :agent
  
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
    
    @agent = WWW::Mechanize.new
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
