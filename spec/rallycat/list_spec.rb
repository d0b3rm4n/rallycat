require 'spec_helper'

# rallycat list                       # by default gives last 5 iterations for your configured project
# rallycat list -s <search phrase>    # do a contains lookup for an iteration
# rallycat list -i <iteration name>   # list all stories for the iteration (ex. [US123] The story name)
# add header that shows the team this sprint belongs to

# sprint = api.find(:iteration, :project => project) { contains :name, '39 (' }.results.first }
# api.find(:hierarchical_requirement, :project => project, :pagesize => 50) { equal :iteration, sprint } }
#
# Idea: keep a log of last (n) stories typed into `cat` so rallycat cat will show last (n) stories


describe Rallycat::List, '#iterations' do

  before do
    responder = lambda do |env|
      # 'https://rally1.rallydev.com/slm/webservice/current/user'
      [200, {}, ['<foo />']]
    end

    Artifice.activate_with responder do
      @api = Rallycat::Connection.new('foo.bar@rallycat.com', 'password').api
    end
  end

  it 'returns last five iterations for the configured project' do
    expected = <<-LIST
# 5 Most recent iterations for "SuperBad"

25 (2012-05-01 to 2012-05-05)
24 (2012-04-01 to 2012-04-05)
23 (2012-03-01 to 2012-03-05)
22 (2012-02-01 to 2012-02-05)
21 (2012-01-01 to 2012-01-05)

    LIST

    Artifice.activate_with RallyIterationsResponder.new do
      project = 'SuperBad'
      list = Rallycat::List.new(@api)
      list.iterations(project).should == expected
    end
  end

  it 'raises when project name is empty' do
    lambda {
      list = Rallycat::List.new(@api)
      list.iterations('').should == expected
    }.should raise_error(ArgumentError, 'Project name is required.')
  end

  it 'raises when project name is nil' do
    lambda {
      list = Rallycat::List.new(@api)
      list.iterations(nil).should == expected
    }.should raise_error(ArgumentError, 'Project name is required.')
  end

  it 'raises when project cannot be found' do
    Artifice.activate_with RallyNoResultsResponder.new do
      lambda {
        list = Rallycat::List.new(@api)
        list.iterations('WebFarts').should == expected
      }.should raise_error(Rallycat::List::ProjectNotFound, 'Project (WebFarts) does not exist.')
    end
  end

  it 'user friendly message when project has no iterations' do
    Artifice.activate_with RallyIterationsResponder.new do
      project = 'SuperAwful'
      list = Rallycat::List.new(@api)
      list.iterations(project).should == 'No iterations could be found for project SuperAwful.'
    end
  end
end
