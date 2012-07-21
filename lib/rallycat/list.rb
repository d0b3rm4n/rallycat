module Rallycat
  class List
    class ProjectNotFound < StandardError; end

    def initialize(api)
      @api = api
    end

    def iterations(project_name)
      if project_name.nil? || project_name.empty?
        raise ArgumentError, 'Project name is required.'
      end

      project = @api.find(:project) { equal :name, project_name }.first

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
  end
end
