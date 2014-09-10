require 'rest_client'

class PivotalTracker

  def initialize(token)
    @token = token
  end

  def get_story(id)
    RestClient.get("https://www.pivotaltracker.com/services/v5/stories/#{id}",
                   :content_type => 'application/json', :accept => :json, :'X-TrackerToken' => @token)
  end

  def get_project_release_stories(project, release_label)
    RestClient.get("https://www.pivotaltracker.com/services/v5/projects/#{project}/stories?filter=label%3A#{release_label}%20includedone:true",
                   :content_type => 'application/json', :accept => :json, :'X-TrackerToken' => @token)
  end

  def get_release_stories(projects, release_label)

    projects.flat_map { |p|
      story_summary(get_project_release_stories(p, release_label))
    }

  end

  def get_iteration_stories(project, iteration)

    iteration_json = RestClient.get("https://www.pivotaltracker.com/services/v5/projects/#{project}/iterations?limit=1&offset=#{iteration.to_i - 1}",
                   :content_type => 'application/json', :accept => :json, :'X-TrackerToken' => @token)
    iteration_stories(iteration_json)
  end

end
