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

describe Rallycat::CLI, '#options' do

  it 'parses global options' do
    sout = StringIO.new
    cli  = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password help }, sout

    cli.options.should == {
      :username => 'foo.bar@rallycat.com',
      :password => 'password'
    }
  end

  it 'raises if global options do not appear before the command' do
    sout = StringIO.new

    lambda {
      cli  = Rallycat::CLI.new %w{ help -u foo.bar@rallycat.com -p password }, sout
    }.should raise_error(OptionParser::InvalidOption, 'invalid option: -u')
  end

  it 'parses all options' do
    sout = StringIO.new
    cli  = Rallycat::CLI.new %w{ -u foo.bar@rallycat.com -p password update -p TA6666 -b }, sout

    cli.options.should == {
      :username    => 'foo.bar@rallycat.com',
      :password    => 'password',
      :in_progress => true,
      :blocked     => true
    }
  end

  it 'parses command options (no global options)' do
    sout = StringIO.new
    cli  = Rallycat::CLI.new %w{ update TA6666 -pb }, sout

    cli.options.should == {
      :in_progress => true,
      :blocked     => true
    }
  end
end

