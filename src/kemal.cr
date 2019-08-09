require "kemal"

# redefines Kemal Config class to add kind, namespace, command, scriptfile
# and secretkey properties!
class Kemal::Config
  @kind : String = "github"
  @namespace : String = "blankoworld/gachette"
  @command : (String)?
  @scriptfile : (String)?
  @secretkey : (String)?

  property kind, namespace, command, scriptfile, secretkey

  def initialize(@serve_static, @host_binding, @port, @env, @public_folder, @logging, @logger, @error_handler, @always_rescue, @router_included, @default_handlers_setup, @running, @shutdown_message, @handler_position)
  end
end

# redefines Kemal CLI options
Kemal.config.extra_options do |parser|
  config = Kemal.config
  parser.banner = "\
Usage: gachette -k [gitea/github/gitlab] -n user/namespace [arguments]
Example: gachette -k github -n blankoworld/gachette -f script.sh"

  # payload kind: gitea or github or gitlab
  parser.on("-k name", "--kind name", "Kind of webhook: gitea, gitlab, github") do |name|
    config.kind = name
  end

  # namespace from which you will receive the payload
  parser.on("-n name", "--name name", "User namespace. Ex. olivier/gachette") do |name|
    config.namespace = name
  end

  # command: run specific command for the given namespace
  parser.on("-c name", "--command name", "Command to run") do |name|
    config.command = name
  end

  # file: script that content some commands to run for the given namespace
  parser.on("-f name", "--file name", "Script to run") do |name|
    unless File.exists? name
      abort "#{name} file does not exist!"
    end
    config.scriptfile = name
  end

  parser.missing_option do |flag|
    STDERR.puts "WARNING: #{flag} should be set."
    STDERR.puts parser
    exit(1)
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end
