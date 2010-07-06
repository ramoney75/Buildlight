require 'nokogiri'
require 'open-uri'
require 'ostruct'
require 'build_light'
require 'time'

while true
  light = BuildLight.new
  begin
    result = true
	nrofresults = 0

	doc = Nokogiri::XML(open("http://pathtocctray.xml"))

    projects = doc.xpath('//Projects/Project')
	
	now = Time.now.localtime.strftime('%d/%m/%Y %H:%M:%S')
    puts
	puts "--- Current build status at #{now} ---"

    projects.each do |project|
	  build_success = project['lastBuildStatus'] == 'Success'
	  item = OpenStruct.new({:project => project["name"], :success => build_success})
	  result = result && build_success
	  puts "#{item.project}: #{item.success}"
	  nrofresults += 1
	end
	
    if not result
      puts 'Light: failed'
      light.fail
    elsif nrofresults == 0
      puts 'Light: no builds found!'
      light.warning
    else
      puts 'Light: success'
      light.success
    end


    sleep(20)
  end
end

