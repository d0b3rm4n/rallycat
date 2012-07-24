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

    def run
      case @command
      when 'cat'
        api = Rallycat::Connection.new(options[:username], options[:password]).api

        story_number = @argv.shift

        abort 'The "cat" command requires a story or defect number.' unless story_number

        @stdout.puts Rallycat::Cat.new(api).story(story_number)
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

        @stdout.puts Rallycat::Update.new(api).task(task_number, opts)
      when 'list'
        api = Rallycat::Connection.new(options[:username], options[:password]).api
        project = options[:project]

        if options[:iteration]
          @stdout.puts Rallycat::List.new(api).stories(project, options[:iteration])
        else
          @stdout.puts Rallycat::List.new(api).iterations(project)
        end
      when 'help'
        # `puts` calls `to_s`
        @stdout.puts Rallycat::Help.new
      else
        @stdout.puts "'#{@command}' is not a supported command. See 'rallycat help'."
      end

    rescue Rallycat::RallycatError => e
      abort e.message
    end

    private

    def parse_global_options!
      @options ||= {}

      global = OptionParser.new do |opts|
        opts.on('-u USERNAME', '--username', 'Your Rally username') do |username|
          @options[:username] = username
        end

        opts.on('-p PASSWORD', '--password', 'Your Rally password') do |password|
          @options[:password] = password
        end

        opts.on('-h', '--help', 'Show this message') do
          @stdout.puts Rallycat::Help.new
          exit
        end
      end

      global.order! @argv
    end

    def parse_command_options!
      @options ||= {}

      commands = {
        'cat' => OptionParser.new do |opts|
          opts.banner = 'Usage: rallycat story <story number>'
        end,

        'update' => OptionParser.new do |opts|
          opts.banner = 'Usage: rallycat update <task number> [options]'

          opts.on('-b', '--blocked', 'Block the current state of a task') do |blocked|
            @options[:blocked] = true
          end

          opts.on('-p', '--in-progress', 'Set the state of a task to "In-Progress"') do |in_progress|
            @options[:in_progress] = true
          end

          opts.on('-c', '--completed', 'Set the state of a task to "Completed"') do |completed|
            @options[:completed] = true
          end

          opts.on('-d', '--defined', 'Set the state of a task to "Defined"') do |defined|
            @options[:defined] = true
          end

          opts.on('-o OWNER', '--owner', 'Set the owner of a task') do |owner|
            @options[:owner] = owner
          end
        end,

        'list' => OptionParser.new do |opts|
          opts.banner = 'Usage: rallycat list [options]'

          opts.on('-p [PROJECT]', '--project', 'The project whose iterations you want to list') do |project|
            @options[:project] = project
          end

          opts.on('-i ITERATION', '--iteration', 'The iteration whose stories you want to list') do |iteration|
            @options[:iteration] = iteration
          end
        end,

        'help' => OptionParser.new do |opts|
          opts.banner = 'Usage: rallycat help'
        end
      }

      @command = @argv.shift
      commands[@command].parse! @argv if commands.has_key? @command
    end
  end
end

