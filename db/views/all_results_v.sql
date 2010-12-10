select tcr.id,
       training_session_name,
       training_name,
       training_code,
       training_course_name,
       course_type,
       score,
       progress,
       attempts,
       total_time,
       du.dokeos_user_name username,
       du.code
from   training_sessions ts,
       training_session_assocs tsa,
       trainings t,
       training_courses tc,
       training_course_results tcr,
       dokeos_users du
where  ts.id = tsa.training_session_id
and    tsa.training_id = t.id
and    t.id = tc.training_id
-- and    training_session_name like '%2009 Aug%'
and    tc.id = tcr.training_course_id
and    tcr.dokeos_user_id = du.id
and    tcr.training_session_id = ts.id
