require 'nokogiri'

module Rallycat
  class Cat

    def initialize(rally_api)
      @rally_api = rally_api
    end

    def story(story_number)
      results = @rally_api.find(:hierarchical_requirement, fetch: true) do
        equal :formatted_id, story_number
      end
      parse_story results.first
    end

    # note: story.elements.keys => all properties exposed by rally
    def parse_story(story)
      <<-TEXT

# [#{story.formatted_i_d}] - #{story.name}

  Plan Estimate:   #{story.plan_estimate}
  State:           #{story.schedule_state}
  Task Actual:     #{story.task_actual_total}
  Task Estimate:   #{story.task_estimate_total}
  Task Remaining:  #{story.task_remaining_total}
  Owner:           #{story.owner}

#{HtmlToTextConverter.new.parse(story.description)}
## TASKS

#{parse_tasks(story)}

TEXT
    end

    def parse_tasks(story)
      return '' unless story.tasks

      tasks        = story.tasks
      sorted_tasks = tasks.sort_by{ |t| t.task_index }

      # This is an example of a task formatted in plain text:
      #
      # [TA12345] [C] The name of the task.
      #
      sorted_tasks.map do |task|
        state =  task.state == 'In-Progress' ? 'P' : task.state[0]
        "[#{task.formatted_i_d}] [#{state}] #{task.name}"
      end.join("\n")
    end
  end
end

