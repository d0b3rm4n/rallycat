require 'spec_helper'

describe Rallycat::CLI do
  it 'should default to STDOUT' do
    STDOUT.should_receive(:puts).with "'' is not a supported command. See 'rallycat help'."
    cli = Rallycat::CLI.new []
    cli.run
  end
end

describe Rallycat::CLI, '#run' do

  it 'should execute command' do
    sout = StringIO.new
    cli  = Rallycat::CLI.new ['foo'], sout

    cli.run

    sout.rewind
    sout.read.should == "'foo' is not a supported command. See 'rallycat help'.\n"
  end
end
