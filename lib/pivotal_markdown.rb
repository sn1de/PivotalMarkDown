require 'json'
require 'pivotal_tracker'

def story_summary(stories_json)
  JSON.parse(stories_json)
end
