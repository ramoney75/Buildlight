# More advanced invocation script for the Delcom build light client.
# This script only changes the light to show success when all known
# projects have built successfully.
#
# Written by Tom Czarniecki, ThoughtWorks

require 'build_light_client'
require 'csv'

HISTORY_FILE = 'project_history'
LIGHT_HOST = 'localhost'
LIGHT_PORT = 1555

project = ARGV[0]
result = ARGV[1]

history = {}

if File.exists? HISTORY_FILE
  File.open(HISTORY_FILE, 'r') do |file|
    CSV::Reader.parse(file, ',') do |row|
      history[row[0]] = row[1]
    end
  end
end

history[project] = result

File.open(HISTORY_FILE, 'w') do |file|
  CSV::Writer.generate(file, ',') do |csv|
    history.each do |key, value|
      csv << [key, value]
    end
  end
end

build_light = BuildLightClient.new(LIGHT_HOST, LIGHT_PORT)
if history.has_value? 'Failure'
  build_light.failure
else
  build_light.success
end
