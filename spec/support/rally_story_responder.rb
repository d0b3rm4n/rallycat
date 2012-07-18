require 'cgi'

class RallyStoryResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)

    case request.url
    when 'https://rally1.rallydev.com/slm/webservice/1.17/task/1'
      [200, {}, [
        <<-XML
          <Task refObjectName="Change link to button">
            <FormattedID>TA1234</FormattedID>
            <State>Complete</State>
            <TaskIndex>1</TaskIndex>
          </Task>
XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/1.17/task/2'
      [200, {}, [
        <<-XML
          <Task refObjectName="Add confirmation">
            <FormattedID>TA1235</FormattedID>
            <State>In-Progress</State>
            <TaskIndex>2</TaskIndex>
          </Task>
XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/1.17/task/3'
      [200, {}, [
        <<-XML
          <Task refObjectName="Code Review">
            <FormattedID>TA1236</FormattedID>
            <State>Defined</State>
            <TaskIndex>3</TaskIndex>
          </Task>
XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/1.17/task/4'
      [200, {}, [
        <<-XML
          <Task refObjectName="QA Test">
            <FormattedID>TA1237</FormattedID>
            <State>Defined</State>
            <TaskIndex>4</TaskIndex>
          </Task>
XML
      ]]
    else
      # https://rally1.rallydev.com/slm/webservice/current/HierarchicalRequirement?query=%28FormattedId+%3D+US7176%29&fetch=true
      [200, {}, [
        <<-XML
          <QueryResult>
            <Results>
              <Object>
                <FormattedID>US4567</FormattedID>
                <Name>[Rework] Change link to button</Name>
                <PlanEstimate>1.0</PlanEstimate>
                <ScheduleState>In-Progress</ScheduleState>
                <TaskActualTotal>0.0</TaskActualTotal>
                <TaskEstimateTotal>6.5</TaskEstimateTotal>
                <TaskRemainingTotal>0.5</TaskRemainingTotal>
                <Owner>scootin@fruity.com</Owner>
                <Description>#{ CGI::escapeHTML('<div><p>This is the story</p></div><ul><li>Remember to do this.</li><li>And this too.</li></ul>') }</Description>
                <Tasks>
                  <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/1" />
                  <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/2" />
                  <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/3" />
                  <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/4" />
                </Tasks>
              </Object>
            </Results>
            <TotalResultCount>1</TotalResultCount>
          </QueryResult>
XML
      ]]
    end
  end
end
