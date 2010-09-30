#!/bin/env ruby

require 'rubygems'
require 'ckuru-tools'
require 'ruby-debug'

emacs_trace do
  dir = "dump." + $$.to_s
  docmd "mkdir #{dir}"
  Dir.glob("app/models/*.rb").each do |model|
    begin
      klass =  model.split(/\//)[2].split(/\./)[0].camelize
      msg_exec "dumping #{klass}" do
        f = File.open "#{dir}/#{klass}.dump", "w"
        f.write AMarshal.dump(klass.constantize.send(:find_all))
        f.close
      end
    rescue Exception => e
      ckebug 0, "skipping #{model}: #{e}"
    end
  end
end


