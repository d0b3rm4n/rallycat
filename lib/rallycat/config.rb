module Rallycat
  class Config
    def initialize
      begin
        @config = YAML.load_file File.expand_path('~/.rallycatrc')
      rescue StandardError
        message = "Your rallycat config file is missing or invalid. See 'rallycat help'."
        raise InvalidConfigError.new message
      end
    end

    def [](key)
      @config[key]
    end
  end
end
