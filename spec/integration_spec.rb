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

      Artifice.activate_with story_responder.endpoint do
        cli.run
      end

      sout.rewind
      sout.read.should include('# [US4567] - [Rework] Change link to button')
    end
  end
end
