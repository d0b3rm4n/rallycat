module Rallycat
  class Update

    def initialize(api)
      @api = api
    end

    def task(task_number, attributes)
      task = find_task(task_number)

      # When we set the state of the task and we don't explicitly set it to
      # blocked we want to remove the block. In our workflow, when you change
      # the state of the task it is also unblocked.
      if attributes[:state] && !attributes[:blocked]
        attributes[:blocked] = false
      end

      # The value in attributes[:owner] should be equal to the desired owner's 
      # display name in Rally. We need to fetch the user in order to get their
      # login_name. The login_name is needed in order to set the owner
      # attribute of a task.
      # 
      # We decided it would be easier for the user to enter 'John Smith'
      # instead of 'john.smith@foobar.com'.
      if display_name = attributes[:owner]
        login_name = find_user(display_name)
        attributes[:owner] = login_name
      end

      # If the task is marked as 'Complete', we should remove the remaining
      # hours.
      if attributes[:state] == "Completed"
        attributes[:to_do] = 0.0
      end

      task.update(attributes)

      messages = []

      if attributes[:state]
        messages << state_message(task_number, attributes[:state])
      end

      if attributes[:blocked]
        messages << blocked_message(task_number)
      end

      if attributes[:owner]
        messages << owner_message(task_number, display_name)
      end

      messages.join("\n")
    end

    private
    def find_task(task_number)
      results = @api.find(:task) do
        equal :formatted_id, task_number
      end

      if results.total_result_count == 0
        raise TaskNotFound, "Task (#{task_number}) does not exist."
      end

      results.first
    end

    def find_user(display_name)
      user_results = @api.find(:user) do
        equal :display_name, display_name
      end

      if user_results.total_result_count == 0
        raise UserNotFound, "User (#{display_name}) does not exist."
      end

      user_results.first.login_name
    end

    def state_message(task_number, state)
      %{Task (#{task_number}) was set to "#{state}".}
    end

    def blocked_message(task_number)
      "Task (#{task_number}) was blocked."
    end

    def owner_message(task_number, owner)
      %{Task (#{task_number}) was assigned to "#{owner}".}
    end
  end
end
