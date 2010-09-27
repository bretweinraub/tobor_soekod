module DokeosRobot
  module Sessions

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
        crawl_user(:id => user.dokeos_user.dokeos_id)
      end
    end


    ################################################################################

    def crawl_session(h={})
      url = h[:url]
      id = h[:id]
      
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
                                              :training_session_name => session_name
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
                                   :conditions => {:training_id => t.training_id,
                                     :training_session_id => training_session.training_session_id},
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
                                         :conditions => {:training_session_id => training_session.training_session_id,
                                           :dokeos_user_id => dokeos_user.dokeos_user_id})
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


  
  end
end
  
