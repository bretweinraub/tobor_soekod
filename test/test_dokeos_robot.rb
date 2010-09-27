#!/usr/bin/env ruby



I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2=1

require File.join(File.dirname(__FILE__),'..','lib','dokeos_robot')
require 'ckuru-tools'

args = CkuruTools::ArgsProcessor.new(:args => ["command","id","-reload","start_with","only",
                                               "+login","+password","+url"])
response = args.parse

emacs_trace do 

  da = DokeosAgent.new(:login => response[:login],
                       :password => response[:password],
                       :url => response[:url])
  da.send(response[:command],response)
end

