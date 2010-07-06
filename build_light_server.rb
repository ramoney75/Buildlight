# Delcom build light controller and CruiseControl integration
#
# Written by Josh Price, ThoughtWorks

require 'build_light'
require 'socket' 

class CruiseSocketListener
	include Socket::Constants 

	METHODS = { "Success" => :success, "Failure" => :fail, "Building" => :building }

	def initialize(build_light, port = 1555) 
		puts "CruiseControl Build Light Server (c) Josh Price 2007"
		puts "Ready to receive build status messages on port #{port}."
		server = TCPServer.new(port)
		while (session = server.accept) 
			state = session.gets
			cmd = METHODS[state]
			build_light.send cmd if cmd
			puts "[#{Time.now.strftime("%d/%m/%Y %H:%M:%S")}] Received '#{state}'" if cmd
			session.close
			sleep 1
		end 
	end 
end

CruiseSocketListener.new(BuildLight.new, 1555)
