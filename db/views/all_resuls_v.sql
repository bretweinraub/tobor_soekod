select training_session_name,
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
from   training_session ts,
       training_session_assoc tsa,
       training t,
       training_course tc,
       training_course_result tcr,
       dokeos_user du
where  ts.training_session_id = tsa.training_session_id
and    tsa.training_id = t.training_id
and    t.training_id = tc.training_id
-- and    training_session_name like '%2009 Aug%'
and    tc.training_course_id = tcr.training_course_id
and    tcr.dokeos_user_id = du.dokeos_user_id
