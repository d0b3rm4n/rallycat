class RallyDefectResponder

  attr_reader :requests

  def initialize
    @requests = []
  end

  def last_request
    @requests.last
  end

  def endpoint
    lambda do |env|
      @requests << request = Rack::Request.new(env)

      case request.url
      when "https://rally1.rallydev.com/slm/webservice/current/Defect?query=%28FormattedId+%3D+DE1234%29&fetch=true"
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
      end
    end
  end
end
