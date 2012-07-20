class RallyIterationsResponder < GenericResponder

  def call(env)
    @requests << request = Rack::Request.new(env)

    case request.url
    when 'https://rally1.rallydev.com/slm/webservice/current/Project?query=%28Name+%3D+SuperBad%29'
      [200, {}, [
        <<-XML
          <QueryResult>
            <Results>
              <Object ref="https://rally1.rallydev.com/slm/webservice/1.36/project/777555" type="Project">
                <Name>SuperBad</Name>
              </Object>
            </Results>
          </QueryResult>
        XML
      ]]
    when 'https://rally1.rallydev.com/slm/webservice/current/Iteration?query=%28ObjectID+%3E+0%29&project=https%3A%2F%2Frally1.rallydev.com%2Fslm%2Fwebservice%2F1.36%2Fproject%2F777555&order=Startdate+desc&pagesize=10'
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
    end
  end
end
