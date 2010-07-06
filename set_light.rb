require 'build_light'

begin
	BuildLight.new.send ARGV[0]
rescue Exception
	puts "Usage:\n\truby build_light.rb <success|fail|building|reset>"
end
