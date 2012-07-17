module Rallycat
  class Update
    def initialize(api)
      @api = api
    end

    def task(task_number, attributes)
      results = @api.find(:task) do
        equal :formatted_id, task_number
      end

      task = results.first

      if attributes[:state] && !attributes[:blocked]
        attributes[:blocked] = false
      end

      user_name = attributes[:owner]

      if user_name
        user_results = @api.find(:user) do
          equal :display_name, user_name
        end
        attributes[:owner] = user_results.first.login_name
      end

      task.update(attributes)

      messages = []

      messages << %{Task (#{task_number}) was set to "#{attributes[:state]}".} if attributes[:state]
      messages << "Task (#{task_number}) was blocked." if attributes[:blocked]
      messages << %{Task (#{task_number}) was assigned to "#{user_name}".} if attributes[:owner]

      messages.join("\n")
    end
  end
end
