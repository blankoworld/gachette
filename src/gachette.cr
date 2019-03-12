require "kemal"
require "json"
require "./gachette/helpers/*"
require "./gitea.cr"
require "./github.cr"
require "./gitlab.cr"

# Gachette is a **webhook service for Gitlab, Github and Gitea** to launch
# specific commands on specific repositories.

# variables initialization
kind = nil       # Payload kind: gitea or github or gitlab
namespace = nil  # Namespace from which you receive a payload
command = nil    # Command to run
scriptfile = nil # Script to launch
secretkey = nil  # secret key
ALLOWED_KINDS = ["gitea", "github", "gitlab"]

# redefines Kemal CLI options
Kemal.config.extra_options do |parser|
  parser.banner = "\
Usage: gachette -k [gitea/github/gitlab] -n user/namespace [arguments]
Example: gachette -k github -n blankoworld/gachette -f script.sh"

  # payload kind: gitea or github or gitlab
  parser.on("-k name", "--kind name", "Kind of webhook: gitea, gitlab, github") do |name|
    kind = name
  end

  # namespace from which you will receive the payload
  parser.on("-n name", "--name name", "User's namespace. Ex. olivier/gachette") do |name|
    namespace = name
  end

  # command: run specific command for the given namespace
  parser.on("-c name", "--command name", "Command to run") do |name|
    command = name
  end

  # file: script that content some commands to run for the given namespace
  parser.on("-f name", "--file name", "Script to run") do |name|
    unless Dir.exists? name
      abort "#{name} file does not exist!"
    end
    scriptfile = name
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

# `Payload` content is what the remote hook server gives us.
# It describes data we could use to find which command we should use.
# For example *project* is the project name(space).
class Payload
  def initialize(kind : (String | Nil), req : HTTP::Request)
    @project = "unknown"
    case kind
      when "gitea"
        gitea = Gitea::Payload.from_json(req.body.not_nil!)
        @project = gitea.repository.full_name
      when "github"
        github = Github::Payload.from_json(req.body.not_nil!)
        @project =  github.repository.full_name
      when "gitlab"
        gitlab = Gitlab::Payload.from_json(req.body.not_nil!)
        @project = gitlab.project.path_with_namespace
    end
  end

  # namespace of given project. Example: blankoworld/gachette
  def project
    @project
  end
end

# Homepage: display simple service homepage
get "/" do
  "J'ai la gachette facile !"
end

# payload process:
#
# 1/ check which kind of payload we receive among "gitlab, gitea, github, nil"
# 2/ launch specific process
post "/" do |env|

  # Stop process if no kind found
  if !kind
    log("unknown kind of payload received")
    puts Kemal.config.extra_options
    next
  end

  payload = Payload.new kind, env.request  
  log("#{kind} payload received: #{payload.project}")

  kind
end

# Start service as Kemal one
# First check mandatories options
Kemal.run do |config|
  secretkey = ENV["GACHETTE_KEY"] if ENV.has_key?("GACHETTE_KEY")
  # mandatories options
  if !kind
    puts "kind option missing!"
    exit(1)
  elsif !ALLOWED_KINDS.includes?(kind)
    puts "`#{kind}` kind is not allowed! Use on of: #{ALLOWED_KINDS}"
    exit (1)
  end
  if !namespace
    puts "name option is missing!"
    exit (1)
  end
  if !command && !scriptfile
    puts "need something to run!"
    exit (1)
  end
end
