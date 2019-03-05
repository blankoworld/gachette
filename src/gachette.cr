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
  def self. gitea(req)
    payload = Gitea.from_json(req.body.not_nil!)
    log("#{payload.repository.full_name} gitea repository")
  end

  def self. github(req)
    payload = Github.from_json(req.body.not_nil!)
    log("#{payload.repository.full_name} github repository")
  end

  def self. gitlab(req)
    payload = Gitlab.from_json(req.body.not_nil!)
    log("#{payload.project.path_with_namespace} gitlab repository")
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
  kind = payload_type(env.request.headers)

  # Stop process if no kind found
  if !kind
    log("unknown payload received")
    next
  end

  log("#{kind} payload received")

  case kind
  when "gitea" then Gachette.gitea(env.request)
  when "github" then Gachette.github(env.request)
  when "gitlab" then Gachette.gitlab(env.request)
  end

  kind
end

# start service as Kemal one
Kemal.run
