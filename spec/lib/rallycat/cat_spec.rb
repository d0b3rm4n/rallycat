require 'spec_helper'
require 'cgi'

describe Rallycat::Cat, '#story' do

  before do
    responder = lambda do |env|
      # 'https://rally1.rallydev.com/slm/webservice/current/user'
      [200, {}, ['<foo>bar</foo>']]
    end

    Artifice.activate_with responder do
      @api = Rallycat::Connection.new('foo.bar@rallycat.com', 'password').api
    end
  end

  it 'outputs the rally story' do

    expected = <<-STORY

# [US4567] - [Rework] Change link to button

  Plan Estimate:   1.0
  State:           In-Progress
  Task Actual:     0.0
  Task Estimate:   6.5
  Task Remaining:  0.5
  Owner:           scootin@fruity.com

## DESCRIPTION

This is the story

  * Remember to do this.
  * And this too.

## TASKS

[TA1234] [C] Change link to button
[TA1235] [P] Add confirmation
[TA1236] [D] Code Review
[TA1237] [D] QA Test

STORY

    responder = RallyStoryResponder.new

    Artifice.activate_with responder do
      story_num = 'US7176'
      cat = Rallycat::Cat.new(@api)
      cat.story(story_num).should == expected
    end
  end

  it 'parses the defect' do

    expected = <<-STORY

# [DE1234] - [Rework] Change link to button

  Plan Estimate:   1.0
  State:           In-Progress
  Task Actual:     0.0
  Task Estimate:   6.5
  Task Remaining:  0.5
  Owner:           scootin@fruity.com

## DESCRIPTION

This is a defect.

## TASKS

STORY

    responder = RallyDefectResponder.new

    Artifice.activate_with responder do
      story_num = 'DE1234'
      cat = Rallycat::Cat.new(@api)
      cat.story(story_num).should == expected
    end
  end

  it 'displays nothing under the tasks section when there are no tasks' do


    responder = lambda do |env|
      [200, {}, [
        <<-XML
          <QueryResult>
            <Results>
              <Object>
                <FormattedID>US4567</FormattedID>
                <Name>Sky Touch</Name>
                <Description>#{ CGI::escapeHTML('<div>As a user<br /> ISBAT touch the sky.</div>') }</Description>
              </Object>
            </Results>
            <TotalResultCount>1</TotalResultCount>
          </QueryResult>
XML
      ]]
    end

    expected = <<-STORY

# [US4567] - Sky Touch

  Plan Estimate:   
  State:           
  Task Actual:     
  Task Estimate:   
  Task Remaining:  
  Owner:           

## DESCRIPTION

As a user
ISBAT touch the sky.

## TASKS

STORY

    Artifice.activate_with responder do
      story_num = 'US4567'
      cat = Rallycat::Cat.new(@api)
      cat.story(story_num).should == expected
    end
  end

  it 'raises when the story does not exist' do
    responder = lambda do |env|
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
    end

    Artifice.activate_with responder do
      story_num = "US9999"
      cat = Rallycat::Cat.new(@api)

      lambda {
        cat.story(story_num)
       }.should raise_error(Rallycat::Cat::StoryNotFound, 'Story (US9999) does not exist.')
    end
  end
end

