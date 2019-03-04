# TODO: Write documentation for `Gachette`
require "kemal"
require "json"

get "/" do
  "J'ai la gachette facile !"
end

post "/" do |env|
  result = "Message reçu."
  head = env.request.headers
  agent = head.fetch("User-Agent", "None")
  if agent == "GiteaServer" && head.has_key?("X-Gitea-Event")
    result += "\ndemande Gitea"
  elsif agent.starts_with?("GitHub-Hookshot/") && head.has_key?("X-Github-Event")
    result += "\ndemande Github"
  elsif head.has_key?("X-Gitlab-Event")
    result += "\ndemande Gitlab"
  else
    result += "\ndemande inconnue"
  end
  result
end

Kemal.run
