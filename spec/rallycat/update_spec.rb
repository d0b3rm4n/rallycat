require 'spec_helper'

describe Rallycat::Update do
  def get_post_request(responder)
    responder.requests.detect {|request| request.post? }
  end

  before do
    Artifice.activate_with RallyAuthResponder.new do
      @api = Rallycat::Connection.new('foo.bar@rallycat.com', 'password').api
    end
  end

  context "Tasks" do

    it 'updates the state and removes block' do

      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        update.task(task_num, :state => "In-Progress")
      end

      post_request = get_post_request(responder)

      post_request.path.should == '/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<Blocked>false</Blocked>')
      body.should include('<State>In-Progress</State>')
    end

    it 'updates the state and preserves blocked if blocked given' do

      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        message = update.task(task_num, :state => "In-Progress", :blocked => true)
        message.should include('Task (TA6666) was set to "In-Progress"')
      end

      post_request = get_post_request(responder)

      post_request.path.should == '/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<Blocked>true</Blocked>')
      body.should include('<State>In-Progress</State>')
    end

    it 'sets the todo hours to zero when completing the task' do
      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        message = update.task(task_num, :state => "Completed")
      end

      post_request = get_post_request(responder)

      post_request.path.should == '/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<State>Completed</State>')
      body.should include('<ToDo>0.0</ToDo>')
    end


    it 'blocks the task' do
      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        message = update.task(task_num, :blocked => true)
        message.should include('Task (TA6666) was blocked.')
      end

      post_request = get_post_request(responder)

      post_request.path.should == '/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<Blocked>true</Blocked>')
    end

    it 'assigns the owner' do
      responder = RallyTaskUpdateResponder.new

      Artifice.activate_with responder do
        task_num = "TA6666"
        update = Rallycat::Update.new(@api)
        message = update.task(task_num, :state => 'Completed', :owner => 'Freddy Fender')
        message.should include('Task (TA6666) was assigned to "Freddy Fender"')
      end

      post_request = get_post_request(responder)

      post_request.path.should == '/slm/webservice/1.17/task/12345'

      body =  post_request.body.tap(&:rewind).read
      body.should include('<State>Completed</State>')
      body.should include('<Owner>fred.fender@testing.com</Owner>')
    end
  end

  it 'raises when the user could not be found' do
    responder = RallyTaskUpdateResponder.new

    Artifice.activate_with responder do
      task_num = "TA6666"
      update = Rallycat::Update.new(@api)

      lambda {
        update.task(task_num, :state => 'Completed', :owner => 'Norman Notreal')
      }.should raise_error(Rallycat::UserNotFound, 'User (Norman Notreal) does not exist.')
    end
  end

  it 'raises when the task could not be found' do
    responder = RallyNoResultsResponder.new

    Artifice.activate_with responder do
      task_num = "TA6666"
      update = Rallycat::Update.new(@api)

      lambda {
        update.task(task_num, :state => 'Completed')
      }.should raise_error(Rallycat::TaskNotFound, 'Task (TA6666) does not exist.')
    end
  end
end
