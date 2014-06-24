#!/usr/bin/env ruby

require 'optparse'
require 'pivotal_tracker'
require 'pivotal_markdown'
require 'mark_maker'
options = {}

option_parser = OptionParser.new do |opts|
  opts.on("-t", "--token T", "Pivotal API token") do |t|
    options[:token] = t
  end

  opts.on("-r", "--release R", "Release label in pivotal") do |r|
    options[:release] = r
  end

  opts.on("-p", "--project P", "Pivotal tracker project number") do |p|
    options[:project] = p
  end
end

option_parser.parse!

piv = PivotalTracker.new(options[:token])

stories_json = piv.get_project_release_stories(options[:project], options[:release])

puts MarkMaker.header1("Release " + options[:release])

stories = story_summary(stories_json)
puts MarkMaker.header2("Total Stories: #{stories.size}")

stories.each { |story|
  puts MarkMaker.bullet("#{ story['name'] } : #{story['description']} (#{ MarkMaker.link(story['id'], story['url']) })")
}
# puts story_summary(stories)