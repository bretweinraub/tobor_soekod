#!/bin/bash

home=/home/bweinraub/dev/aura.git/tobor_soekod
run () {
    cd $home ; script/runner $home/old_plugin/test/test_dokeos_robot.rb -l bret.weinraub  -p minimedVENDOR09 -u http://www.medtronicdiabeteseuniversity.com -c $*
}

crawl_trainings () {
    while [ $# -gt 0 ]; do
	t=$1
	run crawl_session --id $t
	run crawl_session_results --id $t
	shift
    done
}
    

# run crawl_trainings
crawl_trainings $1


