require 'optparse'

module Rallycat
  class CLI
    def initialize(argv, stdout=STDOUT)
      @argv   = argv
      @stdout = stdout
    end

    def run
      options = {}
      option_parser = OptionParser.new do |opts|
        opts.on('-u USER') do |user|
          options[:user] = user
        end

        opts.on('-p PASSWORD') do |password|
          options[:password] = password
        end
      end

      option_parser.parse! @argv

      case @argv.shift
      when 'cat'
        api = Rallycat::Connection.new(options[:user], options[:password]).api

        @stdout.puts Rallycat::Cat.new(api).story(@argv.shift)
      else
        @stdout.puts 'only support for `cat` exists at the moment.'
      end
    end
  end
end

