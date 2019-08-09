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
  @kind : String
  @project : String = "unknown"
  def initialize(req : HTTP::Request)
    # request kind
    request_kind = request_type(req.headers).to_s
    @kind = request_kind == "" ? "unknown" : request_kind
    case @kind
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

  # kind of payload.
  def kind
    @kind
  end
end

# Homepage: display simple service homepage
get "/" do
  "J'ai la gachette facile !"
end

# payload process:
#
# 1/ load request in Payload
# 2/ if the payload is the same as expected: process the request
#   For the payload to be the same, there's some criteria:
#    - kind is the same
#    - project is the same as expected
#    - the given secret key is similar
# 3/ request processing: either launch a scriptfile or a command
# 4/ show result
post "/" do |env|
  payload = Payload.new env.request

  # TODO:
  # - check if secret key is OK (if given)
  # - check where to go (directory)

  # Stop process if no kind found
  if !Kemal.config.kind
    log("error: unknown kind of payload received")
    next
  end

  # Check payload
  if payload.kind != Kemal.config.kind.to_s
    log("error: payload kind (#{payload.kind}) is different from: #{Kemal.config.kind}")
    next
  end

  if payload.project != Kemal.config.namespace.to_s
    log("error: payload project (#{payload.project}) didn't match with: #{Kemal.config.namespace}")
    next
  end

  log("#{Kemal.config.kind} payload received. Project: #{payload.project}")

  # Process request
  pwd = Process::INITIAL_PWD
  command = nil
  args = [] of String

  if Kemal.config.scriptfile
    log("Script: #{Kemal.config.scriptfile}")
    command = "sh"
    args << "-c" << Kemal.config.scriptfile.to_s
  else
    log("Launch command: #{Kemal.config.command}")
    command = Kemal.config.command.to_s
  end

  if args.size > 0
    status = Process.run command: command, args: args, shell: true, error: STDERR, output: STDOUT, chdir: pwd
  else
    status = Process.run command: command, shell: true, error: STDERR, output: STDOUT, chdir: pwd
  end

  # 3/ Show result
  result = status.success? ? "SUCCESS" : "FAILURE"
  log("Result: #{result}")

  # TODO: send result as JSON
  result
end

# Start service as Kemal one
# After having checked mandatories options
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
    exit (1)
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
