require 'rallycat/cat'
require 'rallycat/cli'
require 'rallycat/config'
require 'rallycat/connection'
require 'rallycat/help'
require 'rallycat/html_to_text_converter'
require 'rallycat/list'
require 'rallycat/update'
require 'rallycat/version'

module Rallycat
  class RallycatError           < StandardError; end
  class StoryNotFound           < RallycatError; end
  class InvalidConfigError      < RallycatError; end
  class InvalidCredentialsError < RallycatError; end
  class ProjectNotFound         < RallycatError; end
  class IterationNotFound       < RallycatError; end
  class UserNotFound            < RallycatError; end
  class TaskNotFound            < RallycatError; end
end
