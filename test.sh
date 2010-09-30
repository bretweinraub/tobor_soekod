#!/bin/bash

run () {
    cd /home/bweinraub/dev/medtronic/medtronic/portal/rails/ ; script/runner /home/bweinraub/dev/medtronic/medtronic/dokeos/tobor_soekod/test/test_dokeos_robot.rb -l bret.weinraub  -p minimedVENDOR09 -u http://www.medtronicdiabeteseuniversity.com -c $*
}

crawl_trainings () {
    while [ $# -gt 0 ]; do
	t=$1
	run crawl_session --id $t
	run crawl_session_results --id $t
	shift
    done
}
    

#run crawl_trainings
crawl_trainings $1


