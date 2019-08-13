require "./kemal.cr"
require "json"
require "./gachette/helpers/*"
require "openssl/hmac"
require "openssl/sha1"
require "./payload.cr"

# Gachette is a **webhook service for Gitlab, Github and Gitea** to launch
# specific commands on specific repositories.

# variables initialization
ALLOWED_KINDS = ["gitea", "github", "gitlab"]

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

  log(line("="))

  # TODO:
  # - check where to go (directory)

  # Stop process if no kind found
  if !Kemal.config.kind
    kinds = ALLOWED_KINDS.join(separator = " ")
    log("ERROR: kind unknown: '#{Kemal.config.kind}'. Allowed: #{kinds}")
    next
  end

  # Check payload
  if payload.kind != Kemal.config.kind.to_s
    log("ERROR: payload is '#{payload.kind}'. Expected: '#{Kemal.config.kind}'.")
    next
  end

  if payload.project != Kemal.config.namespace.to_s
    log("ERROR: user namespace is '#{payload.project}'. Expected: '#{Kemal.config.namespace}'")
    next
  end

  log("[#{payload.project}]: payload received!")

  # Check secret
  given_secret = Kemal.config.secretkey
  if payload.kind == "github"
    data = JSON.parse(payload.content).to_json
    given_secret = "sha1=" + OpenSSL::HMAC.hexdigest(:sha1, Kemal.config.secretkey, data)
  end
  if payload.secret != given_secret
    log("ERROR: secret is '#{payload.secret}'. Expected: '#{given_secret}'")
    next
  end

  # Process request
  pwd = Process::INITIAL_PWD
  command = nil
  args = [] of String

  if Kemal.config.scriptfile
    log("SCRIPT: #{Kemal.config.scriptfile}")
    command = "sh"
    args << "-c" << Kemal.config.scriptfile.to_s
  else
    log("COMMAND: #{Kemal.config.command}")
    command = Kemal.config.command.to_s
  end

  if args.size > 0
    status = Process.run command: command, args: args, shell: true, error: STDERR, output: STDOUT, chdir: pwd
  else
    status = Process.run command: command, shell: true, error: STDERR, output: STDOUT, chdir: pwd
  end

  # 3/ Show result
  result = status.success? ? "SUCCESS" : "FAILURE"
  log("RESULT: #{result}")

  log(line("="))

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
      config.secretkey = "mot2passe"
    end
  end

  # secret key is mandatory!
  if !config.secretkey || config.secretkey == ""
    puts "GACHETTE_KEY environment variable is mandatory!"
    exit (1)
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
