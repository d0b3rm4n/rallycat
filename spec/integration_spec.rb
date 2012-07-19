require 'spec_helper'

describe 'Rallycat' do

  context 'cat' do

    it 'fetches, parses and outputs the rally story requested by the user' do
      sout = StringIO.new

      cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password cat US4567 }, sout

      story_responder = RallyStoryResponder.new

      Artifice.activate_with story_responder do
        cli.run
      end

      sout.rewind
      sout.read.should include('# [US4567] - [Rework] Change link to button')
    end

    it 'aborts when a story number is not given' do
      sout = StringIO.new

      cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password cat }, sout

      lambda {
        Artifice.activate_with RallyStoryResponder.new do
          cli.run
        end
      }.should raise_error(SystemExit, 'The "cat" command requires a story or defect number.')
    end

    it 'aborts when the story does not exist' do
      sout = StringIO.new

      cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password cat US9999 }, sout

      lambda {
        Artifice.activate_with RallyNoResultsResponder.new do
          cli.run
        end
      }.should raise_error(SystemExit, 'Story (US9999) does not exist.')
    end
  end

  context 'help' do

    it 'displays a help screen to the user' do
      string_io = StringIO.new

      cli = Rallycat::CLI.new %w{ help }, string_io

      cli.run

      string_io.rewind
      expected = string_io.read

      expected.should include("rallycat cat <story number>")
      expected.should include("Displays a user story or defect")
    end
  end

  context 'update' do

    context 'task' do

      it 'sets the state to in-progress' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -p TA6666 }, sout

        task_responder = RallyTaskUpdateResponder.new

        Artifice.activate_with task_responder do
          cli.run
        end

        sout.rewind
        sout.read.should include('Task (TA6666) was set to "In-Progress".')
      end

      it 'sets the state to defined' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -d TA6666 }, sout

        task_responder = RallyTaskUpdateResponder.new

        Artifice.activate_with task_responder do
          cli.run
        end

        sout.rewind
        sout.read.should include('Task (TA6666) was set to "Defined".')
      end

      it 'sets the state to completed' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -c TA6666 }, sout

        task_responder = RallyTaskUpdateResponder.new

        Artifice.activate_with task_responder do
          cli.run
        end

        sout.rewind
        sout.read.should include('Task (TA6666) was set to "Completed".')
      end

      it 'blocks the task' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -b TA6666 }, sout

        task_responder = RallyTaskUpdateResponder.new

        Artifice.activate_with task_responder do
          cli.run
        end

        sout.rewind
        sout.read.should include('Task (TA6666) was blocked.')
      end

      it 'assigns the owner of the task' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -o Freddy\ Fender TA6666 }, sout

        task_responder = RallyTaskUpdateResponder.new

        Artifice.activate_with task_responder do
          cli.run
        end

        sout.rewind
        sout.read.should include('Task (TA6666) was assigned to "Freddy Fender".')
      end

      it 'aborts when the owner does not exist' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -o Norman\ Notreal TA6666 }, sout

        task_responder = RallyTaskUpdateResponder.new

        lambda {
          Artifice.activate_with task_responder do
            cli.run
          end
        }.should raise_error(SystemExit, 'User (Norman Notreal) does not exist.')
      end

      it 'aborts when a task number is not given' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update }, sout

        task_responder = RallyTaskUpdateResponder.new

        lambda {
          Artifice.activate_with task_responder do
            cli.run
          end
        }.should raise_error(SystemExit, 'The "update" command requires a task number.')
      end

      it 'aborts when a task does not exist' do
        sout = StringIO.new

        cli = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -i TA9999 }, sout

        task_responder = RallyNoResultsResponder.new

        lambda {
          Artifice.activate_with task_responder do
            cli.run
          end
        }.should raise_error(SystemExit, 'Task (TA9999) does not exist.')
      end
    end
  end
end
