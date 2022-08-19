require "kemal"

# redefines Kemal Config class to add projects and config properties!
class Kemal::Config
  @projects = Hash(NamedTuple(service: String, namespace: String), Hash(String, String)).new
  @config : String = Dir.new(Dir.current).path + "/gachette.ini"
  @app_name = "Gachette"

  property projects,config

  def initialize(@serve_static, @host_binding, @port, @env, @public_folder, @logging, @logger, @error_handler, @always_rescue, @router_included, @default_handlers_setup, @running, @shutdown_message, @handler_position)
  end
end

# redefines Kemal CLI options
Kemal.config.extra_options do |parser|
  config = Kemal.config
  parser.banner = "\
Usage: gachette -c [configuration_file] [arguments]
Example: gachette -c gachette.ini"

  # configuration file: to configure projects
  parser.on("-c name", "--config name", "Configuration file") do |name|
    unless File.exists? name
      abort "#{name} file does not exist!"
    end
    config.config = name
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
