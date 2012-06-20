require 'spec_helper'
require 'rally_rest_api'
require 'artifice'
require 'cgi'

describe Rallycat::Cat, '#story' do

  before do
    responder = lambda do |env|
      # 'https://rally1.rallydev.com/slm/webservice/current/user'
      [200, {}, ['<foo>bar</foo>']]
    end

    Artifice.activate_with responder do
      @api = RallyRestAPI.new \
       base_url: 'https://rally1.rallydev.com/slm',
       username: 'foo.bar@rallycat.com',
       password: 'password'
    end
  end

  it 'outputs the rally story' do
    responder = lambda do |env|
      @request = Rack::Request.new(env)
      case @request.url
      when 'https://rally1.rallydev.com/slm/webservice/1.17/task/1'
        [200, {}, [
          <<-XML
            <Task refObjectName="Change link to button">
              <FormattedID>TA1234</FormattedID>
              <State>Complete</State>
              <TaskIndex>1</TaskIndex>
            </Task>
XML
        ]]
      when 'https://rally1.rallydev.com/slm/webservice/1.17/task/2'
        [200, {}, [
          <<-XML
            <Task refObjectName="Add confirmation">
              <FormattedID>TA1235</FormattedID>
              <State>In-Progress</State>
              <TaskIndex>2</TaskIndex>
            </Task>
XML
        ]]
      when 'https://rally1.rallydev.com/slm/webservice/1.17/task/3'
        [200, {}, [
          <<-XML
            <Task refObjectName="Code Review">
              <FormattedID>TA1236</FormattedID>
              <State>Defined</State>
              <TaskIndex>3</TaskIndex>
            </Task>
XML
        ]]
      when 'https://rally1.rallydev.com/slm/webservice/1.17/task/4'
        [200, {}, [
          <<-XML
            <Task refObjectName="QA Test">
              <FormattedID>TA1237</FormattedID>
              <State>Defined</State>
              <TaskIndex>4</TaskIndex>
            </Task>
XML
        ]]
      else
        [200, {}, [
          <<-XML
            <QueryResult>
              <Results>
                <Object>
                  <FormattedID>US4567</FormattedID>
                  <Name>[Rework] Change link to button</Name>
                  <PlanEstimate>1.0</PlanEstimate>
                  <ScheduleState>In-Progress</ScheduleState>
                  <TaskActualTotal>0.0</TaskActualTotal>
                  <TaskEstimateTotal>6.5</TaskEstimateTotal>
                  <TaskRemainingTotal>0.5</TaskRemainingTotal>
                  <Owner>scootin@fruity.com</Owner>
                  <Description>#{ CGI::escapeHTML('<div><p>This is the story</p></div><ul><li>Remember to do this.</li><li>And this too.</li></ul>') }</Description>
                  <Tasks>
                    <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/1" />
                    <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/2" />
                    <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/3" />
                    <Task ref="https://rally1.rallydev.com/slm/webservice/1.17/task/4" />
                  </Tasks>
                </Object>
              </Results>
            </QueryResult>
XML
        ]]
      end
    end

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


    Artifice.activate_with responder do
      story_num = 'US7176'
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

  it 'displays User Story not found message when User Story does not exist' do


    responder = lambda do |env|
      @request = Rack::Request.new(env)
      [200, {}, [
        <<-XML
          <OperationResult rallyAPIMajor="1" rallyAPIMinor="34">
            <Errors>
              <OperationResultError>Cannot find object to read</OperationResultError>
            </Errors>
            <Warnings/>
          </OperationResult>
XML
      ]]
    end

    Artifice.activate_with responder do
      story_num = 'US1337'
      expected  = "Story (#{ story_num }) does not exist."
      cat = Rallycat::Cat.new(@api)
      cat.story(story_num).should == expected
    end
  end

end

