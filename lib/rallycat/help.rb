module Rallycat
  class Help
    def to_s
      <<-HELP
Rallycat is a command line utility for interacting with Rally.

Configuration:
  Configuration is available through a ~/.rallycatrc file
  formatted as YAML. The file should have two keys: `username`
  and `password` for authenticating with the Rally API.

  Additionally, the `-u [USERNAME]` and `-p [PASSWORD]` flags
  may be provided at runtime and will take higher precedence
  than the configuration file.

Global Options:
  -u [USERNAME]     The Rally user
  -p [PASSWORD]     The password for the Rally user

Commands:
  rallycat cat [STORY NUMBER]     Displays the user story
  rallycat help                   Displays this help text
      HELP
    end
  end
end
