require "ini"

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

# Read gachette.ini file and return it 
def load_configuration(path : String)
  result = Hash(NamedTuple(service: String, namespace: String), Hash(String, String)).new
  begin
    # TODO: check for each configuration that:
    # 1/ we have service and namespace filled in
    # 2/ we either have command or file filled in (to launch a script)
    INI.parse(File.read(path)).each do |name, options|
      # prepare the key used for indexing service/namespace tuple
      key = {service: options["service"], namespace: options["namespace"]}
      # content is like `options`, but without service and namespace
      options.delete("service")
      options.delete("namespace")
      result[key] = options
    end
  rescue INI::ParseException
    raise "Wrong INI file format!"
  end
  return result
end
# vim: ts=2 sw=2 et nu