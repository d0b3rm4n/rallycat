module Rallycat
  class Help
    def to_s
      <<-HELP
Rallycat is a command-line utility for interacting with Rally. It should be
used to support a command-line centric workflow. Rallycat has the simple goal
of being a lightweight alternative to Rally's web interface. It provides quick
access to Rally features that are important to developers in their day-to-day
work.

Configuration:
  Configuration is available through a ~/.rallycatrc file formatted as YAML.
  The file should have two keys: `username` and `password` for authenticating
  with the Rally API. Example:

    username: email@host.com
    password: pass1234

  Additionally, the `-u [USERNAME]` and `-p [PASSWORD]` flags may be provided
  at runtime and will take higher precedence than the configuration file.

Global Options:
  -u [USERNAME]                           # Your Rally username
  -p [PASSWORD]                           # Your Rally password
  -h, --help                              # Displays this help text

Commands:
  rallycat cat <story number>             # Displays a user story or defect
  rallycat update <task number>           # Updates the state of a task
    [--blocked | -b] [--in-progress | -p]
    [--completed | -c] [--defined | -d]
    [--owner | -o <fullname>]
  rallycat help                           # Displays this help text


      HELP
    end
  end
end
