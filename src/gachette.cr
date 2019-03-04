# TODO: Write documentation for `Gachette`
require "kemal"
require "json"

# Homepage
get "/" do
  "J'ai la gachette facile !"
end

# payload process
post "/" do |env|
  result = "Message reçu : "
  head = env.request.headers
  agent = head.fetch("User-Agent", "None")
  if agent == "GiteaServer" && head.has_key?("X-Gitea-Event")
    result += "type Gitea"
  elsif agent.starts_with?("GitHub-Hookshot/") && head.has_key?("X-Github-Event")
    result += "type Github"
  elsif head.has_key?("X-Gitlab-Event")
    result += "type Gitlab"
  else
    result += "type inconnu (agent >#{agent}<, headers >#{head}<)"
  end
  log(result)
  result
end

Kemal.run
