require 'json'

def story_summary(stories_json)
  JSON.parse(stories_json)
end

def iteration_stories(iteration_json)
  iteration = JSON.parse(iteration_json)
  iteration[0]["stories"]
end