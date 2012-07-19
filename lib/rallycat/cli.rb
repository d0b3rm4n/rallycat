require 'optparse'

module Rallycat
  class CLI
    attr_reader :options

    def initialize(argv, stdout=STDOUT)
      @argv   = argv
      @stdout = stdout

      parse_global_options!
      parse_command_options!
    end

    def parse_global_options!
      @options ||= {}

      global = OptionParser.new do |opts|
        opts.on('-u USERNAME', '--username') do |username|
          @options[:username] = username
        end

        opts.on('-p PASSWORD', '--password') do |password|
          @options[:password] = password
        end

        opts.on('-h', '--help') do
          @stdout.puts Rallycat::Help.new
          exit
        end
      end

      global.order! @argv
    end

    def parse_command_options!
      @options ||= {}

      commands = {
        'cat' => OptionParser.new,

        'update' => OptionParser.new do |opts|
          opts.banner = 'Usage: rallycat update <story number> [options]'

          opts.on('-b', '--blocked') do |blocked|
            @options[:blocked] = true
          end

          opts.on('-p', '--in-progress') do |in_progress|
            @options[:in_progress] = true
          end

          opts.on('-c', '--completed') do |completed|
            @options[:completed] = true
          end

          opts.on('-d', '--defined') do |defined|
            @options[:defined] = true
          end

          opts.on('-o OWNER', '--owner') do |owner|
            @options[:owner] = owner
          end
        end,

        'help' => OptionParser.new
      }

      @command = @argv.shift
      commands[@command].parse! @argv if commands.has_key? @command
    end

    def run
      case @command
      when 'cat'
        api = Rallycat::Connection.new(options[:username], options[:password]).api

        story_number = @argv.shift

        abort 'The "cat" command requires a story or defect number.' unless story_number

        begin
          @stdout.puts Rallycat::Cat.new(api).story(story_number)
        rescue Rallycat::Cat::StoryNotFound => e
          abort e.message
        end
      when 'update'
        api = Rallycat::Connection.new(options[:username], options[:password]).api

        task_number = @argv.shift

        abort 'The "update" command requires a task number.' unless task_number

        opts = {}
        opts[:blocked] = true            if options[:blocked]
        opts[:state]   = "In-Progress"   if options[:in_progress]
        opts[:state]   = "Completed"     if options[:completed]
        opts[:state]   = "Defined"       if options[:defined]
        opts[:owner]   = options[:owner] if options[:owner]

        begin
          @stdout.puts Rallycat::Update.new(api).task(task_number, opts)
        rescue Rallycat::Update::UserNotFound, Rallycat::Update::TaskNotFound => e
          abort e.message
        end
      when 'help'
        # `puts` calls `to_s`
        @stdout.puts Rallycat::Help.new
      else
        @stdout.puts "'#{@command}' is not a supported command. See 'rallycat help'."
      end
    end
  end
end

