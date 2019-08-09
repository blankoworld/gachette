# Gives request type regarding given *headers*
def request_type(headers : HTTP::Headers)
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

# Return 80 times the given String
def line(s : String)
  "#{s*80}"
end
