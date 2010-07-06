# Invocation script for the Delcom build light client.
#
# Written by Tom Czarniecki, ThoughtWorks

require 'build_light_client'

LIGHT_HOST = 'localhost'
LIGHT_PORT = 1555

message = ARGV[0]

METHODS = { "Success" => :success, "Failure" => :failure, "Building" => :building }
command = METHODS[message]

build_light = BuildLightClient.new(LIGHT_HOST, LIGHT_PORT)
build_light.send command if command
