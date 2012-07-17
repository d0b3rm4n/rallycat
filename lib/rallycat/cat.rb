require 'nokogiri'

module Rallycat
  class Cat
    class StoryNotFound < StandardError; end

    def initialize(rally_api)
      @rally_api = rally_api
    end

    def story(story_number)
      story_type = story_number.start_with?('US') ? :hierarchical_requirement : :defect

      results = @rally_api.find(story_type, fetch: true) do
        equal :formatted_id, story_number
      end

      if results.total_result_count == 0
        raise StoryNotFound, "Story (#{ story_number }) does not exist."
      end

      consolidate_newlines parse_story(results.first)
    end

    private

    # NOTE: story.elements.keys => all properties exposed by rally
    def parse_story(story)
      <<-TEXT

# [#{story.formatted_i_d}] - #{story.name}

  Plan Estimate:   #{story.plan_estimate}
  State:           #{story.schedule_state}
  Task Actual:     #{story.task_actual_total}
  Task Estimate:   #{story.task_estimate_total}
  Task Remaining:  #{story.task_remaining_total}
  Owner:           #{story.owner}

## DESCRIPTION

#{HtmlToTextConverter.new(story.description).parse}

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

    def consolidate_newlines(story)
      story.gsub(/\n{3,}/, "\n\n")
    end
  end
end

