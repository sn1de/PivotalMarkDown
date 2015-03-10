#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'optparse'
require 'pivotal_tracker'
require 'pivotal_markdown'
require 'mark_maker'
require 'pp'
require 'yaml'

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

  opts.on("-i", "--iteration I", "Pivotal tracker iteration number") do |i|
    options[:iteration] = i
  end

  opts.on("-s", "--save", "Save the configuration options as a YAML file") do |s|
    options[:save] = s
  end
end

option_parser.parse!

if (options[:release])
  puts "Generating release report ..."
  projects = options[:project].split(',')

  piv = PivotalTracker.new(options[:token])
  stories = piv.get_release_stories(projects, options[:release])

  puts MarkMaker.header1("Release " + options[:release])

  # stories = story_summary(stories_json)
  puts MarkMaker.header2("Total Stories: #{stories.size}")

  stories.each { |story|
    puts MarkMaker.bullet("#{ story['name'] } : #{story['description']} (#{ MarkMaker.link(story['id'], story['url']) })")
  }
end

if (options[:iteration])
  puts "Generating iteration report ... project #{options[:project]} iteration #{options[:iteration]}"
  
  # check to make sure only a single project is specified in the options
  if options[:project].split(',').size > 1
    puts "Iteration reports only work within a single projects context. Try again with only one projet id."
  else
    piv = PivotalTracker.new(options[:token])
    stories = piv.get_iteration_stories(options[:project], options[:iteration])
    
    puts MarkMaker.header1("Iteration #{options[:iteration]}")
    stories.each { |story|
      puts MarkMaker.bullet("#{ story['name'] } : #{story['description']} (#{ MarkMaker.link(story['id'], story['url']) })")
    }
  end
end

if (options[:save])
  puts "Saving options ..."
  # don't forget to remove the save option
  puts YAML.dump(options)
  puts "done."
end

