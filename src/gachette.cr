# TODO: Write documentation for `Gachette`
require "kemal"
require "json"
require "./gachette/helpers/*"

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
  log("#{kind} payload received")
  kind
end

Kemal.run
