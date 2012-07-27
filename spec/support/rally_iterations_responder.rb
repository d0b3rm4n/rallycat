class RallyIterationsResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)

    case request.path
    when '/slm/webservice/current/Project'
      if request.params["query"].include? "SuperBad"
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object ref="/slm/webservice/1.36/project/777555" type="Project">
                  <Name>SuperBad</Name>
                </Object>
              </Results>
            </QueryResult>
          XML
        ]]
      elsif request.params["query"].include? "SuperAwful"
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object ref="/slm/webservice/1.36/project/888444" type="Project">
                  <Name>SuperAwful</Name>
                </Object>
              </Results>
            </QueryResult>
          XML
        ]]
      else
        RallyNoResultsResponder.new.call(env)
      end
    when '/slm/webservice/current/Iteration'
      if request.params["project"].include? "777555" # Project ID
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object type="Iteration">
                  <Name>25 (2012-05-01 to 2012-05-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>25 (2012-05-01 to 2012-05-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>24 (2012-04-01 to 2012-04-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>24 (2012-04-01 to 2012-04-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>23 (2012-03-01 to 2012-03-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>23 (2012-03-01 to 2012-03-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>22 (2012-02-01 to 2012-02-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>22 (2012-02-01 to 2012-02-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>21 (2012-01-01 to 2012-01-05)</Name>
                </Object>
                <Object type="Iteration">
                  <Name>21 (2012-01-01 to 2012-01-05)</Name>
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
