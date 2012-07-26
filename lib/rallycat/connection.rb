require 'yaml'
require 'rally_rest_api'
require 'logger'

module Rallycat 
  class Connection
    attr_reader :api

    def initialize(username=nil, password=nil)
      @config = Config.new

      username ||= @config['username']
      password ||= @config['password']

      begin
        logger = ENV['RALLY_DEBUG'] ? Logger.new(STDOUT) : Logger.new(nil)

        @api = RallyRestAPI.new \
         base_url: 'https://rally1.rallydev.com/slm',
         username: username,
         password: password,
         logger: logger

      rescue Rally::NotAuthenticatedError
        raise InvalidCredentialsError.new('Your Rally credentials are invalid.')
      end
    end
  end
end

