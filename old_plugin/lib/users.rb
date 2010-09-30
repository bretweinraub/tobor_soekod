module DokeosRobot
  module Users

    def crawl_user(h={})
      id = h[:id]


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
            
            if score_page = get_page("main/mySpace/myStudents.php?student=#{id}&details=true&course=#{training.training_code}&origin=&id_session=#infosStudent")
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
                                                   :training_id => training.training_id,
                                                   :training_course_name => course,
                                                   :course_type => 'test'
                                                 },
                                                 :required => true)

                training_course_result = find_or_create(:klass => TrainingCourseResult,
                                                        :conditions => {
                                                          :training_course_id => training_course.training_course_id,
                                                          :dokeos_user_id => dokeos_user.dokeos_user_id
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
                                                   :training_id => training.training_id,
                                                   :training_course_name => course,
                                                   :course_type => 'course'
                                                 },
                                                 :required => true)

                training_course_result = find_or_create(:klass => TrainingCourseResult,
                                                        :conditions => {
                                                          :training_course_id => training_course.training_course_id,
                                                          :dokeos_user_id => dokeos_user.dokeos_user_id
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
  end
end
