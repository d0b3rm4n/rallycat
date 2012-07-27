class RallyDefectResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)

    case request.path
    when "/slm/webservice/current/Defect"
      [200, {}, [
        <<-XML
          <QueryResult>
            <Results>
              <Object>
                <FormattedID>DE1234</FormattedID>
                <Name>[Rework] Change link to button</Name>
                <PlanEstimate>1.0</PlanEstimate>
                <ScheduleState>In-Progress</ScheduleState>
                <TaskActualTotal>0.0</TaskActualTotal>
                <TaskEstimateTotal>6.5</TaskEstimateTotal>
                <TaskRemainingTotal>0.5</TaskRemainingTotal>
                <Owner>scootin@fruity.com</Owner>
                <Description>#{ CGI::escapeHTML('<div><p>This is a defect.</p></div>') }</Description>
              </Object>
            </Results>
            <TotalResultCount>1</TotalResultCount>
          </QueryResult>
XML
      ]]
    else
      RallyNoResultsResponder.new.call(env)
    end
  end
end
