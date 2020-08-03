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
get "/" do |env|
  env.redirect "/index.html"
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
  if !ALLOWED_KINDS.includes?(payload.kind)
    kinds = ALLOWED_KINDS.join(separator = " ")
    log("ERROR: kind unknown: '#{payload.kind}'. Allowed: #{kinds}")
    # TODO: Error in JSON
    next
  end

  key = {service: payload.kind, namespace: payload.project}
  if !Kemal.config.projects.has_key?(key)
    log("WARNING: no corresponding project found for #{payload.kind} with #{payload.project} namespace.")
    # TODO: Error in JSON
    next
  end

  log("[#{payload.project}]: payload received!")
  project = Kemal.config.projects[key]

  # Check secret
  project_key = project["key"]? || ""
  given_secret = project_key
  if payload.kind == "github"
    data = JSON.parse(payload.content).to_json
    given_secret = "sha1=" + OpenSSL::HMAC.hexdigest(:sha1, project_key, data)
  end
  if payload.secret != given_secret
    log("ERROR: secret is '#{payload.secret}'. Expected: '#{given_secret}'")
    # TODO: Error in JSON
    next
  end

  # Process request
  pwd = Process::INITIAL_PWD
  command = nil
  args = [] of String

  if project.has_key?("scriptfile")
    scriptfile = project["scriptfile"]
    log("SCRIPT: #{scriptfile}")
    command = "sh"
    args << "-c" << scriptfile.to_s
  else
    command = project["command"]
    log("COMMAND: #{command}")
    command = command.to_s
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
Kemal.run do |config|
  # Check configuration file: should exist and be loadable
  configuration = Kemal.config.config
  # Use gachette.ini.example for tests
  if ENV["KEMAL_ENV"]? == "test" && configuration == Dir.new(Dir.current).path + "/gachette.ini"
    configuration = Dir.new(Dir.current).path + "/gachette.ini.example"
  end
  if ! File.exists?(configuration)
    raise "Configuration '#{configuration}' not found!"
  end

  begin
    config.projects = load_configuration(configuration)
  rescue
    raise "Loading '#{configuration}' failed!"
  end
end
# vim: ts=2 sw=2 et nu
