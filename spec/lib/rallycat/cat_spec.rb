require 'spec_helper'
require 'rally_rest_api'
require 'nokogiri'

describe Rallycat::Cat, '#story' do

  it 'outputs the rally story' do
    VCR.use_cassette('connection') do
      @api = RallyRestAPI.new \
       base_url: 'https://rally1.rallydev.com/slm',
       username: 'foo.bar@rallycat.com',
       password: 'password',
       logger:   nil
    end

    expected = <<-STORY

# [US7176] - [ENG] add new sending failure with new error messages

  Plan Estimate:   1.0
  State:           In-Progress
  Task Actual:     0.0
  Task Estimate:   6.5
  Task Remaining:  0.5
  Owner:           foo.blah@bar.com

 new sending failures from the sending failures report on production:

  * 'Twitter::Error::Forbidden: Status is over 140 characters.'
  * 'Koala::Facebook::APIError: OAuthException: (#100) The targeting param has invalid values for: countries'
  * 'Koala::Facebook::APIError: OAuthException: (#100) The status you are trying to publish is a duplicate of, or too similar to, one that we recently posted to Twitter'
  * 'Koala::Facebook::APIError: OAuthException: (#100) Sorry, this post contains a blocked URL'
  * 'Koala::Facebook::APIError: OAuthException: Warning: This Message Contains Blocked Content: Some content in this message has been reported as abusive by Facebook users.'

We need to get the correct user facing errors off mikey.

NOTE:
- Here's the google doc with all updated error messages and user-friendly translations. Updated error messages and translations are in red:
https://docs.google.com/a/wildfireapp.com/spreadsheet/ccc?key=0Aq5Y5yHYSsIKdFc1dEVvdE9EZVg3V0pKbFJCZUVYVkE#gid=0

QA:
I would not bother trying to reproduce each individual case. just adding them to the whitelist should be sufficient.

## TASKS

[TA22035] [C] Add errors to the error whitelist with correct user facing message.
[TA22119] [C] Dev QA
[TA22120] [C] Code Review
[TA22122] [C] Confirm on am-test
[TA22121] [C] Deploy to am-test
[TA22123] [C] QA Test
[TA22124] [D] Demo to product owner

STORY

    VCR.use_cassette('user_story') do
      story_num = 'US7176'
      cat = Rallycat::Cat.new(@api)
      cat.story(story_num).should == expected
    end
  end

end
