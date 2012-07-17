require 'spec_helper'

describe Rallycat::Update do
  before do
    auth_responder = lambda do |env|
      # 'https://rally1.rallydev.com/slm/webservice/current/user'
      [200, {}, ['<foo>bar</foo>']]
    end

    Artifice.activate_with auth_responder do
      @api = Rallycat::Connection.new('foo.bar@rallycat.com', 'password').api
    end
  end

  context "Tasks" do

    it 'updates the state and removes block' do

      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        update.task(task_num, state: "In-Progress")
      end

      post_request = responder.requests[2] # this is the request that actually updates the task
      post_request.should be_post
      post_request.url.should == 'https://rally1.rallydev.com/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<Blocked>false</Blocked>')
      body.should include('<State>In-Progress</State>')
    end

    it 'updates the state and preserves blocked if blocked given' do

      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        message = update.task(task_num, state: "In-Progress", blocked: true)
        message.should include('Task (TA6666) was set to "In-Progress"')
      end

      post_request = responder.requests[2] # this is the request that actually updates the task
      post_request.should be_post
      post_request.url.should == 'https://rally1.rallydev.com/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<Blocked>true</Blocked>')
      body.should include('<State>In-Progress</State>')
    end


    it 'blocks the task' do
      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        message = update.task(task_num, blocked: true)
        message.should include('Task (TA6666) was blocked.')
      end

      post_request = responder.requests[2] # this is the request that actually updates the task
      post_request.should be_post
      post_request.url.should == 'https://rally1.rallydev.com/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<Blocked>true</Blocked>')
    end

    it 'assigns the owner' do
      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        message = update.task(task_num, state: 'Completed', owner: 'Freddy Fender')
        message.should include('Task (TA6666) was assigned to "Freddy Fender"')
      end

      post_request = responder.requests[4] # this is the request that actually updates the task
      post_request.should be_post
      post_request.url.should == 'https://rally1.rallydev.com/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<State>Completed</State>')
      body.should include('<Owner>fred.fender@testing.com</Owner>')
    end
  end

  it 'raises when the user could not be found' do
    responder = RallyNoResultsResponder.new

    Artifice.activate_with responder do
      task_num = "TA6666"
      update = Rallycat::Update.new(@api)

      lambda {
        update.task(task_num, state: 'Completed', owner: 'Norman Notreal')
      }.should raise_error(Rallycat::Update::UserNotFound, 'User (Norman Notreal) does not exist.')
    end
  end
end