require 'spec_helper'

describe Rallycat::CLI do
  it 'should default to STDOUT' do
    STDOUT.should_receive(:puts).with 'only support for `cat` exists at the moment.'
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
    sout.read.should == "only support for `cat` exists at the moment.\n"
  end
end
