class RallyStoriesResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)

    case request.url
    when 'https://rally1.rallydev.com/slm/webservice/current/Project?query=%28Name+%3D+SuperBad%29'
      [200, {}, [
        <<-XML
          <QueryResult>
            <Results>
              <Object ref="https://rally1.rallydev.com/slm/webservice/1.17/project/777555" type="Project" />
            </Results>
          </QueryResult>
        XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/1.17/project/777555'
      [200, {}, [
        <<-XML
          <Project ref="https://rally1.rallydev.com/slm/webservice/1.17/project/777555">
            <Name>SuperBad</Name>
          </Project>
        XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/current/Iteration?query=%28Name+%3D+%2225+%282012-05-01+to+2012-05-05%29%22%29&project=https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.17%2Fproject%2F777555'
      [200, {}, [
        # NOTE: Always getting two results back from Rally, not sure why.
        <<-XML
          <QueryResult>
            <Results>
              <Object ref="https://rally1.rallydev.com/slm/webservice/1.17/iteration/1234" type="Iteration" />
              <Object ref="https://rally1.rallydev.com/slm/webservice/1.17/iteration/4567" type="Iteration" />
            </Results>
          </QueryResult>
        XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/1.17/iteration/1234'
      [200, {}, [
        <<-XML
          <Iteration>
            <Name>25 (2012-05-01 to 2012-05-05)</Name>
          </Iteration>
        XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/current/HierarchicalRequirement?query=%28Iteration+%3D+%29&project=https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.17%2Fproject%2F777555&pagesize=100&fetch=true'
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
    when 'https://rally1.rallydev.com/slm/webservice/current/Defect?query=%28Iteration+%3D+%29&project=https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.17%2Fproject%2F777555&pagesize=100&fetch=true'
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

    # These are for testing the not so happy path.
    when 'https://rally1.rallydev.com/slm/webservice/current/Iteration?query=%28Name+%3D+%22Sprint+0%22%29&project=https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.17%2Fproject%2F777555'
      RallyNoResultsResponder.new.call(env)
    when 'https://rally1.rallydev.com/slm/webservice/current/Iteration?query=%28Name+%3D+%2226+%282012-06-01+to+2012-06-05%29%22%29&project=https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.17%2Fproject%2F777555'
      [200, {}, [
        <<-XML
          <QueryResult>
            <Results>
              <Object ref="https://rally1.rallydev.com/slm/webservice/1.17/iteration/7890" type="Iteration" />
            </Results>
          </QueryResult>
        XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/1.17/iteration/7890'
      # does nothing WTF(but will make tests fail if not here)???
    when 'https://rally1.rallydev.com/slm/webservice/current/HierarchicalRequirement?query=%28Iteration+%3D+https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.17%2Fiteration%2F7890%29&project=https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.17%2Fproject%2F777555&pagesize=100&fetch=true'
      RallyNoResultsResponder.new.call(env)
    else
      RallyNoResultsResponder.new.call(env)
    end
  end
end
