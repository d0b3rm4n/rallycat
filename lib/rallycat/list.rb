module Rallycat
  class List
    class ProjectNotFound < StandardError; end
    class IterationNotFound < StandardError; end

    def initialize(api)
      @api = api
    end

    def iterations(project_name)
      if project_name.nil? || project_name.empty?
        raise ArgumentError, 'Project name is required.'
      end

      project = @api.find(:project) { equal(:name, project_name) }.first

      unless project
        raise ProjectNotFound, "Project (#{project_name}) does not exist."
      end

      iterations = @api.find_all(:iteration, {
        project: project,
        order: 'StartDate desc',
        pagesize: 10
      }).results

      if iterations.count == 0
        return "No iterations could be found for project #{project_name}."
      end

      iteration_names = iterations.map(&:name).uniq

      <<-LIST
# 5 Most recent iterations for "#{project_name}"

#{iteration_names.join("\n")}

      LIST
    end

    def stories(project_name, iteration_name)
      if project_name.nil? || project_name.empty?
        raise ArgumentError, 'Project name is required.'
      end

      if iteration_name.nil? || iteration_name.empty?
        raise ArgumentError, 'Iteration name is required.'
      end

      project = @api.find(:project) { equal(:name, project_name) }.first

      unless project
        raise ProjectNotFound, "Project (#{project_name}) does not exist."
      end

      iteration = @api.find(:iteration, :project => project) {
        equal(:name, iteration_name)
      }.first

      unless iteration
        raise IterationNotFound, "Iteration (#{iteration_name}) does not exist."
      end

      stories = @api.find(:hierarchical_requirement, {
        project: project,
        pagesize: 100,
        fetch: true
      }) { equal :iteration, iteration }.results

      if stories.count == 0
        return %{No stories could be found for iteration "#{iteration_name}".}
      end

      list = %{# Stories for iteration "#{iteration_name}" - "#{project_name}"\n\n}

      stories.each do |story|
        state = story.schedule_state == 'In-Progress' ? 'P' : story.schedule_state[0]
        list += "* [#{story.formatted_i_d}] [#{state}] #{story.name}\n"
      end

      list += "\n"
    end
  end
end

