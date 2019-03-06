# TODO: Write documentation for `Gachette`
require "kemal"
require "json"
require "./gachette/helpers/*"
require "./gitea.cr"
require "./github.cr"
require "./gitlab.cr"

# Gachette is a **webhook service for Gitlab, Github and Gitea** to launch
# specific commands on specific repositories.
class Gachette
end

# `Payload` content is what the remote hook server gives us.
# It describes data we could use to find which command we should use.
# For example *project* is the project name(space).
class Payload
  def initialize(kind : String, req : HTTP::Request)
    @project = "unknown"
    case kind
      when "gitea"
        gitea = Gitea.from_json(req.body.not_nil!)
        @project = gitea.repository.full_name
      when "github"
        github = Github.from_json(req.body.not_nil!)
        @project =  github.repository.full_name
      when "gitlab"
        gitlab = Gitlab.from_json(req.body.not_nil!)
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

  kind = request_type(env.request.headers)
  # Stop process if no kind found
  if !kind
    log("unknown payload received")
    next
  end

  payload = Payload.new kind, env.request  
  log("#{kind} payload received: #{payload.project}")

  kind
end

# start service as Kemal one
Kemal.run
