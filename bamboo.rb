require 'hpricot'
require 'open-uri'
require 'ostruct'
require 'build_light'
require 'time'

critical_builds = []
critical_builds << OpenStruct.new({:project => 'DEMO', :plan => 'BUILD'})

non_critical_builds = []
non_critical_builds << OpenStruct.new({:project => 'DEMONONCRIT', :plan => 'TEST'})

builds = critical_builds + non_critical_builds

build_pattern = /^(\w+)-(\w+)-([0-9]+) \w+ (\w+).*$/

build_result_url = "http://somebamboourl/rss/createAllBuildsRssFeed.action?feedType\x3drssAll"

while true
  light = BuildLight.new
  begin
    results = []

	doc = Hpricot.XML(open(build_result_url))

    titles = doc.search('//item/title')

    titles.each do |title|
      md = build_pattern.match(title.inner_html)
      if md
        build_success = (md[4] == 'SUCCESSFUL')
        item = OpenStruct.new({:project => md[1], :plan => md[2], :build_number => md[3].to_i, :success => build_success})
        if builds.find { |build| build.project == item.project && build.plan == item.plan }
          results << item
        end
      end
    end

    latest = {}
    results.each do |item|
      build = builds.find { |build| build.project == item.project && build.plan == item.plan }
      if latest.has_key? build
        if latest[build].build_number < item.build_number
          latest[build] = item
        end
      else
        latest[build] = item
      end
    end

    puts
    now = Time.now.localtime.strftime('%d/%m/%Y %H:%M:%S')
    puts "Latest build results at #{now}"
    puts
    latest.values.each { |item| puts "#{item.project}-#{item.plan}-#{item.build_number} success: #{item.success}" }

    latest_wihout_non_critical_builds = latest.values.reject do |build|
        non_critical_builds.find {|non_critical_build| non_critical_build.project == build.project and non_critical_build.plan == build.plan}
    end

    if latest_wihout_non_critical_builds.find { |build| not build.success }
      puts 'Light: failed'
      light.fail
    elsif latest.values.find { |build| not build.success }
      puts 'Light: partial success'
      light.partial_success
    elsif latest.empty?
      puts 'Light: no builds found!'
      light.warning
    else
      puts 'Light: success'
      light.success
    end

  rescue Timeout::Error => e
	puts "Caught timeout error #{e.inspect}, retrying..."
	light.warning
	next
  rescue
    puts "Something bad has happened: #{$!}"
    light.warning
	next
  end
  sleep(90)
end
