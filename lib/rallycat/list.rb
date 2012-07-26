module Rallycat
  class List

    def initialize(api)
      @api = api
      @config = Config.new
    end

    def iterations(project_name)
      project_name ||= @config['project']

      validate_arg project_name, 'Project name is required.'

      project = find_project(project_name)

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
      project_name ||= @config['project']

      validate_arg project_name,   'Project name is required.'
      validate_arg iteration_name, 'Iteration name is required.'

      project   = find_project(project_name)
      iteration = find_iteration(iteration_name, project)

      stories = @api.find(:hierarchical_requirement, {
        project: project,
        pagesize: 100,
        fetch: true
      }) { equal :iteration, iteration }.results

      stories += @api.find(:defect, {
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

    private

    def validate_arg(val, message)
      raise ArgumentError, message if val.nil? || val.empty?
    end

    def find_project(project_name)
      project = @api.find(:project) { equal(:name, project_name) }.first

      raise ProjectNotFound, "Project (#{project_name}) does not exist." unless project

      project
    end

    def find_iteration(iteration_name, project)
      iteration = @api.find(:iteration, :project => project) {
        equal(:name, iteration_name)
      }.first

      raise IterationNotFound, "Iteration (#{iteration_name}) does not exist." unless iteration

      iteration
    end
  end
end

