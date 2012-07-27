class RallyStoriesResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)

    case request.path
    when '/slm/webservice/current/Project'
      if request.params["query"].include? "SuperBad"
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object ref="https://rally1.rallydev.com/slm/webservice/1.17/project/777555" type="Project" />
              </Results>
            </QueryResult>
          XML
        ]]
      else
        RallyNoResultsResponder.new.call(env)
      end
    when '/slm/webservice/1.17/project/777555'
      [200, {}, [
        <<-XML
          <Project ref="https://rally1.rallydev.com/slm/webservice/1.17/project/777555">
            <Name>SuperBad</Name>
          </Project>
        XML
      ]]
    when '/slm/webservice/current/Iteration'
      if request.params["query"].include? '25 (2012-05-01 to 2012-05-05)'
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object ref="https://rally1.rallydev.com/slm/webservice/1.17/iteration/1234" type="Iteration" />
              </Results>
            </QueryResult>
          XML
        ]]
      elsif request.params["query"].include? '26 (2012-06-01 to 2012-06-05)'
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object ref="https://rally1.rallydev.com/slm/webservice/1.17/iteration/7890" type="Iteration" />
              </Results>
            </QueryResult>
          XML
        ]]
      else
        RallyNoResultsResponder.new.call(env)
      end
    when '/slm/webservice/1.17/iteration/1234'
      [200, {}, [
        <<-XML
          <Iteration ref="https://https://rally1.rallydev.com/slm/webservice/1.17/iteration/1234">
            <Name>25 (2012-05-01 to 2012-05-05)</Name>
          </Iteration>
        XML
      ]]
    when '/slm/webservice/current/HierarchicalRequirement'
      if request.params["query"].include? '1234' # Iteration ID
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object type="HierarchicalRequirement">
                  <FormattedID>US123</FormattedID>
                  <Name>This is story number one</Name>
                  <ScheduleState>Completed</ScheduleState>
                </Object>
                <Object type="HierarchicalRequirement">
                  <FormattedID>US456</FormattedID>
                  <Name>This is story number two</Name>
                  <ScheduleState>In-Progress</ScheduleState>
                </Object>
              </Results>
            </QueryResult>
          XML
        ]]
      else
        RallyNoResultsResponder.new.call(env)
      end
    when '/slm/webservice/current/Defect'
      if request.params["query"].include? '1234' # Iteration ID
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object type="Defect">
                  <FormattedID>DE789</FormattedID>
                  <Name>This is defect number one</Name>
                  <ScheduleState>Defined</ScheduleState>
                </Object>
              </Results>
            </QueryResult>
          XML
        ]]
      else
        RallyNoResultsResponder.new.call(env)
      end
    else
      RallyNoResultsResponder.new.call(env)
    end
  end
end
