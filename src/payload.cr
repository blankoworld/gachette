require "./gachette/helpers/*"
require "./gitea.cr"
require "./github.cr"
require "./gitlab.cr"

# `Payload` content is what the remote hook server gives us.
# It describes data we could use to find which command we should use.
# Properties:
# - kind:     payload type. For an example: gitea, github or gitlab
# - project:  project name(space).
# - secret:   shared secret to check you're allowed to launch the command/script
class Payload
  @kind : String
  @project : String = "unknown"
  @secret : String = ""
  @content : String

  def initialize(req : HTTP::Request)
    # request kind
    request_kind = request_type(req.headers).to_s
    @kind = request_kind == "" ? "unknown" : request_kind
    # content
    @content = req.body.not_nil!.gets_to_end.to_s
    case @kind
    when "gitea"
      gitea = Gitea::Payload.from_json(@content)
      @project = gitea.repository.full_name
      @secret = gitea.secret
    when "github"
      github = Github::Payload.from_json(@content)
      @project = github.repository.full_name
      hash = req.headers.fetch("X-Hub-Signature", "None")
      if hash != "None"
        @secret = hash.to_s
      end
    when "gitlab"
      gitlab = Gitlab::Payload.from_json(@content)
      @project = gitlab.project.path_with_namespace
      token = req.headers.fetch("X-Gitlab-Token", "None")
      if token != "None"
        @secret = token.to_s
      end
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

  # special secret from project
  def secret
    @secret
  end

  # payload content (body)
  def content
    @content
  end
end
