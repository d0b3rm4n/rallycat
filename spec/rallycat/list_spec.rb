require 'spec_helper'

describe Rallycat::List, '#iterations' do

  before do
    Artifice.activate_with RallyAuthResponder.new do
      @api = Rallycat::Connection.new('foo.bar@rallycat.com', 'password').api
    end
  end

  it 'returns last five iterations for the project provided' do
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

  it 'returns last five iterations for the configured project in .rallycatrc' do
    expected = <<-LIST
# 5 Most recent iterations for "SuperBad"

25 (2012-05-01 to 2012-05-05)
24 (2012-04-01 to 2012-04-05)
23 (2012-03-01 to 2012-03-05)
22 (2012-02-01 to 2012-02-05)
21 (2012-01-01 to 2012-01-05)

    LIST

    Artifice.activate_with RallyIterationsResponder.new do
      rc_file = File.expand_path("~/.rallycatrc")
      YAML.stub(:load_file).with(rc_file).and_return({
        'project' => 'SuperBad'
      })
      list = Rallycat::List.new(@api)
      list.iterations(nil).should == expected
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
      rc_file = File.expand_path("~/.rallycatrc")
      YAML.stub(:load_file).with(rc_file).and_return({})

      list = Rallycat::List.new(@api)
      list.iterations(nil).should == expected
    }.should raise_error(ArgumentError, 'Project name is required.')
  end

  it 'raises when project cannot be found' do
    Artifice.activate_with RallyNoResultsResponder.new do
      lambda {
        list = Rallycat::List.new(@api)
        list.iterations('WebFarts').should == expected
      }.should raise_error(Rallycat::ProjectNotFound, 'Project (WebFarts) does not exist.')
    end
  end

  it 'returns a user friendly message when project has no iterations' do
    Artifice.activate_with RallyIterationsResponder.new do
      project = 'SuperAwful'
      list = Rallycat::List.new(@api)
      list.iterations(project).should == 'No iterations could be found for project SuperAwful.'
    end
  end
end

describe Rallycat::List, '#stories' do
  before do
    Artifice.activate_with RallyAuthResponder.new do
      @api = Rallycat::Connection.new('foo.bar@rallycat.com', 'password').api
    end
  end

  it 'returns the stories for an iteration filtered by sprint' do
    expected = <<-LIST
# Stories for iteration "25 (2012-05-01 to 2012-05-05)" - "SuperBad"

* [US123] [C] This is story number one
* [US456] [P] This is story number two
* [DE789] [D] This is defect number one

    LIST

    Artifice.activate_with RallyStoriesResponder.new do
      project = 'SuperBad'
      iteration = '25 (2012-05-01 to 2012-05-05)'
      list = Rallycat::List.new(@api)
      list.stories(project, iteration).should == expected
    end
  end

  it 'raises when project name is empty' do
    lambda {
      list = Rallycat::List.new(@api)
      list.stories('', '25 (2012-05-01 to 2012-05-05)').should == expected
    }.should raise_error(ArgumentError, 'Project name is required.')
  end

  it 'raises when project name is nil' do
    lambda {
      rc_file = File.expand_path("~/.rallycatrc")
      YAML.stub(:load_file).with(rc_file).and_return({})

      list = Rallycat::List.new(@api)
      list.stories(nil, '25 (2012-05-01 to 2012-05-05)').should == expected
    }.should raise_error(ArgumentError, 'Project name is required.')
  end

  it 'raises when iteration name is empty' do
    lambda {
      list = Rallycat::List.new(@api)
      list.stories('SuperBad', '').should == expected
    }.should raise_error(ArgumentError, 'Iteration name is required.')
  end

  it 'raises when iteration name is nil' do
    lambda {
      list = Rallycat::List.new(@api)
      list.stories('SuperBad', nil).should == expected
    }.should raise_error(ArgumentError, 'Iteration name is required.')
  end

  it 'raises when project cannot be found' do
    Artifice.activate_with RallyNoResultsResponder.new do
      lambda {
        list = Rallycat::List.new(@api)
        list.stories('WebFarts', '25 (2012-05-01 to 2012-05-05)')
      }.should raise_error(Rallycat::ProjectNotFound, 'Project (WebFarts) does not exist.')
    end
  end

  it 'raises when iteration cannot be found' do
    Artifice.activate_with RallyStoriesResponder.new do
      lambda {
        list = Rallycat::List.new(@api)
        list.stories('SuperBad', 'Sprint 0')
      }.should raise_error(Rallycat::IterationNotFound, 'Iteration (Sprint 0) does not exist.')
    end
  end

  it 'returns a user friendly message when iteration has no stories' do
    Artifice.activate_with RallyStoriesResponder.new do
      project = 'SuperBad'
      iteration = '26 (2012-06-01 to 2012-06-05)'
      list = Rallycat::List.new(@api)
      list.stories(project, iteration).should == 'No stories could be found for iteration "26 (2012-06-01 to 2012-06-05)".'
    end
  end
end

