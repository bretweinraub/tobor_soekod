# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'dokeos_robot'

task :default => 'spec:run'

PROJ.name = 'dokeos_robot'
PROJ.authors = 'Ckuru LLC'
PROJ.email = 'front-door@ckuru.com'
PROJ.url = 'http://www.ckuru.com'
PROJ.version = DokeosRobot::VERSION
PROJ.rubyforge.name = 'dokeos_robot'

PROJ.spec.opts << '--color'

# EOF
