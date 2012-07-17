class RallyTaskUpdateResponder

  attr_reader :requests

  def initialize
    @requests = []
  end

  def last_request
    @requests.last
  end

  def call(env)
    @requests << request = Rack::Request.new(env)

    if request.url == 'https://rally1.rallydev.com/slm/webservice/current/Task?query=%28FormattedId+%3D+TA6666%29'
      [200, {}, [
        <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <QueryResult rallyAPIMajor="1" rallyAPIMinor="17">
            <TotalResultCount>1</TotalResultCount>
            <StartIndex>1</StartIndex>
            <PageSize>20</PageSize>
            <Results>
              <Object rallyAPIMajor="1" rallyAPIMinor="17" ref="https://rally1.rallydev.com/slm/webservice/1.17/task/12345" refObjectName="Tie your shoes!" type="Task" />
            </Results>
          </QueryResult>
        XML
      ]]
    elsif request.get? && request.url == 'https://rally1.rallydev.com/slm/webservice/1.17/task/12345'
      [200, {}, [
        <<-XML
          <Task rallyAPIMajor="1" rallyAPIMinor="17" ref="https://rally1.rallydev.com/slm/webservice/1.17/task/12345" objectVersion="8" refObjectName="Tie your shoes!" CreatedAt="today at 8:31 pm">
            <CreationDate>2012-07-17T03:31:33.801Z</CreationDate>
            <ObjectID>12345</ObjectID>
            <Description />
            <Discussion />
            <FormattedID>TA6666</FormattedID>
            <LastUpdateDate>2012-07-17T04:00:35.888Z</LastUpdateDate>
            <Name>Tie your shoes!</Name>
            <Notes />
            <Owner>tester@testing.com</Owner>
            <Tags />
            <Attachments />
            <Blocked>false</Blocked>
            <Rank>4000</Rank>
            <State>Defined</State>
            <TaskIndex>2</TaskIndex>
            <ToDo>2.0</ToDo>
          </Task>
        XML
      ]]
    elsif request.post? && request.url == 'https://rally1.rallydev.com/slm/webservice/1.17/task/12345'
      [200, {}, ['<?xml version="1.0" encoding="UTF-8"?><OperationResult rallyAPIMajor="1" rallyAPIMinor="17"><Errors /><Warnings /></OperationResult>']]
    elsif request.url == 'https://rally1.rallydev.com/slm/webservice/current/User?query=%28DisplayName+%3D+%22Freddy+Fender%22%29'
      [200, {}, [
        <<-XML
          <QueryResult rallyAPIMajor="1" rallyAPIMinor="17">
            <Errors />
            <Warnings />
            <TotalResultCount>1</TotalResultCount>
            <StartIndex>1</StartIndex>
            <PageSize>20</PageSize>
            <Results>
              <Object rallyAPIMajor="1" rallyAPIMinor="17" ref="https://rally1.rallydev.com/slm/webservice/1.17/user/4567" refObjectName="Freddy Fender" type="User" />
            </Results>
          </QueryResult>
        XML
      ]]
    elsif request.url == 'https://rally1.rallydev.com/slm/webservice/current/User?query=%28DisplayName+%3D+%22Norman+Notreal%22%29'
      [200, {}, [
        <<-XML
          <QueryResult rallyAPIMajor="1" rallyAPIMinor="17">
          <Errors/>
          <Warnings/>
          <TotalResultCount>0</TotalResultCount>
          <StartIndex>1</StartIndex>
          <PageSize>20</PageSize>
          <Results/>
          </QueryResult>
        XML
     ]]
    elsif request.url == 'https://rally1.rallydev.com/slm/webservice/1.17/user/4567'
      [200, {}, [
        <<-XML
          <User rallyAPIMajor="1" rallyAPIMinor="17" ref="https://rally1.rallydev.com/slm/webservice/1.17/user/4567" objectVersion="50" refObjectName="Freddy Fender">
            <ObjectID>4567</ObjectID>
            <Disabled>false</Disabled>
            <DisplayName>Freddy Fender</DisplayName>
            <EmailAddress>fred.fender@testing.com</EmailAddress>
            <FirstName>Freddy</FirstName>
            <LastName>Fender</LastName>
            <LoginName>fred.fender@testing.com</LoginName>
          </User>
        XML
      ]]
    else
      [200, {}, ['<else />']]
    end
  end
end
