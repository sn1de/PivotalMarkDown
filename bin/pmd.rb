#!/usr/bin/env ruby

require 'optparse'
require 'pivotal_tracker'
require 'pivotal_markdown'

options = {}

option_parser = OptionParser.new do |opts|
  opts.on("-t", "--token T", "Pivotal API token") do |t|
    options[:token] = t
  end
end

option_parser.parse!

piv = PivotalTracker.new(options[:token])

# puts piv.get_story(72257134)

stories_json = piv.get_project_release_stories("29622", "web-2.54.0")
stories = story_summary(stories_json)
puts "Total Stories: #{stories.size}"
stories.each { |story|
  puts "-----------------------------------------------------------"
  puts "#{story['id']} - #{story['name']}"
  puts story['description']
}
# puts story_summary(stories)