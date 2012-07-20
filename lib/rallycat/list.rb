module Rallycat
  class List
    def initialize(api)
      @api = api
    end

    def iterations(project_name)
      project = @api.find(:project) { equal :name, project_name }.first

      results = @api.find_all(:iteration, { 
        project: project,
        order: 'StartDate desc',
        pagesize: 10
      }).results

      iterations = results.map(&:name).uniq

      <<-LIST
# 5 Most recent iterations for "#{project_name}"

#{iterations.join("\n")}

      LIST
    end
  end
end
