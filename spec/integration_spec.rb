require 'spec_helper'

describe 'Rallycat' do

  context 'cat' do

    it 'fetches, parses and outputs the rally story requested by the user' do
      auth_responder = lambda do |env|
        # 'https://rally1.rallydev.com/slm/webservice/current/user'
        [200, {}, ['<foo>bar</foo>']]
      end

      sout = StringIO.new
      cli  = nil

      Artifice.activate_with auth_responder do
        cli = Rallycat::CLI.new %w{ cat US4567 -u=foo.bar@rallycat.com -p=password'}, sout
      end

      story_responder = RallyStoryResponder.new

      Artifice.activate_with story_responder do
        cli.run
      end

      sout.rewind
      sout.read.should include('# [US4567] - [Rework] Change link to button')
    end
  end

  context 'help' do
    it 'displays a help screen to the user' do
      string_io = StringIO.new

      cli = Rallycat::CLI.new %w{ help }, string_io

      cli.run

      string_io.rewind
      expected = string_io.read

      expected.should include("rallycat cat [STORY NUMBER]")
      expected.should include("Displays the user story")
    end
  end
end
