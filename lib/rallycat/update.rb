module Rallycat
  class Update
    class UserNotFound < StandardError; end
    class TaskNotFound < StandardError; end

    def initialize(api)
      @api = api
    end

    def task(task_number, attributes)
      results = @api.find(:task) do
        equal :formatted_id, task_number
      end

      if results.total_result_count == 0
        raise TaskNotFound, "Task (#{task_number}) does not exist."
      end

      task = results.first

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
      if user_name = attributes[:owner]
        user_results = @api.find(:user) do
          equal :display_name, user_name
        end

        if user_results.total_result_count == 0
          raise UserNotFound, "User (#{attributes[:owner]}) does not exist."
        end

        attributes[:owner] = user_results.first.login_name
      end

      task.update(attributes)

      messages = []

      if attributes[:state]
        messages << %{Task (#{task_number}) was set to "#{attributes[:state]}".}
      end

      if attributes[:blocked]
        messages << "Task (#{task_number}) was blocked."
      end

      if attributes[:owner]
        messages << %{Task (#{task_number}) was assigned to "#{user_name}".}
      end

      messages.join("\n")
    end
  end
end
