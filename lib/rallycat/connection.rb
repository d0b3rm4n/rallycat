require 'yaml'
require 'rally_rest_api'

module Rallycat
  class InvalidConfigError < StandardError; end
  class InvalidCredentialsError < StandardError; end

  class Connection
    attr_reader :api

    def initialize(username=nil, password=nil)
      @username = username
      @password = password

      config = parse_config

      begin
        @api = RallyRestAPI.new \
         base_url: 'https://rally1.rallydev.com/slm',
         username: config.fetch('username'),
         password: config.fetch('password')
      rescue Rally::NotAuthenticatedError
        raise InvalidCredentialsError.new('Your Rally credentials are invalid.')
      end
    end

    private

    def parse_config
      rc_file_path = File.expand_path '~/.rallycatrc'

      if @username || @password
        { 'username' => @username, 'password' => @password }
      else
        begin
          YAML.load_file(rc_file_path)
        rescue StandardError
          message = "Your rallycat config file is missing or invalid. Please RTFM."
          raise InvalidConfigError.new message
        end
      end
    end
  end
end
