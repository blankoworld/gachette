# Gives payload type regarding given *headers*
def payload_type(headers : HTTP::Headers)
  result = nil
  agent = headers.fetch("User-Agent", "None")
  if agent == "GiteaServer" && headers.has_key?("X-Gitea-Event")
    result = "gitea"
  elsif agent.starts_with?("GitHub-Hookshot/") && headers.has_key?("X-Github-Event")
    result = "github"
  elsif headers.has_key?("X-Gitlab-Event")
    result = "gitlab"
  end
  result
end
