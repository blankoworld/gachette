require "./kemal.cr"
require "json"
require "./gachette/helpers/*"
require "./gitea.cr"
require "./github.cr"
require "./gitlab.cr"

# Gachette is a **webhook service for Gitlab, Github and Gitea** to launch
# specific commands on specific repositories.

# variables initialization
ALLOWED_KINDS = ["gitea", "github", "gitlab"]

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
  if !Kemal.config.kind
    log("unknown kind of payload received")
    next
  end

  payload = Payload.new Kemal.config.kind, env.request  
  log("#{Kemal.config.kind} payload received: #{payload.project}")

  Kemal.config.kind
end

# Start service as Kemal one
# First check mandatories options
Kemal.run do |config|
  # miscellaneous initialization
  config.secretkey = ENV["GACHETTE_KEY"] if ENV.has_key?("GACHETTE_KEY")
  if kemal_env = ENV["KEMAL_ENV"]?
      if kemal_env == "test"
        config.kind = "github"
        config.namespace = "blankoworld/gachette"
        config.command = "echo \"Testing env. with github:blankoworld/gachette\""
    end
  end

  # mandatories options
  if !config.kind
    puts "kind option missing!"
    exit(1)
  elsif !ALLOWED_KINDS.includes?(config.kind)
    puts "`#{config.kind}` kind is not allowed! Use one of: #{ALLOWED_KINDS}"
    exit (1)
  end
  if !config.namespace
    puts "name option is missing!"
    exit (1)
  end
  if !config.command && !config.scriptfile
    puts "need something to run! Either a command or a scriptfile."
    exit (1)
  end
end
