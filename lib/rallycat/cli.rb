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
        opts.on('-u USERNAME', '--username') do |user|
          options[:user] = user
        end

        opts.on('-p PASSWORD', '--password') do |password|
          options[:password] = password
        end

        opts.on('-b', '--blocked') do |blocked|
          options[:blocked] = true
        end

        opts.on('-i', '--in-progress') do |in_progress|
          options[:in_progress] = true
        end

        opts.on('-c', '--completed') do |completed|
          options[:completed] = true
        end

        opts.on('-d', '--defined') do |defined|
          options[:defined] = true
        end

        opts.on('-o OWNER', '--owner') do |owner|
          options[:owner] = owner
        end
      end

      option_parser.parse! @argv

      case @argv.shift
      when 'cat'
        api = Rallycat::Connection.new(options[:user], options[:password]).api

        @stdout.puts Rallycat::Cat.new(api).story(@argv.shift)
      when 'update'
        api = Rallycat::Connection.new(options[:user], options[:password]).api


        task_number = @argv.shift

        opts = {}
        opts[:blocked] = true            if options[:blocked]
        opts[:state]   = "In-Progress"   if options[:in_progress]
        opts[:state]   = "Completed"     if options[:completed]
        opts[:state]   = "Defined"       if options[:defined]
        opts[:owner]   = options[:owner] if options[:owner]

        @stdout.puts Rallycat::Update.new(api).task(task_number, opts)
      when 'help'
        # `puts` calls `to_s`
        @stdout.puts Rallycat::Help.new
      else
        @stdout.puts 'only support for `cat` exists at the moment.'
      end
    end
  end
end

