require "json"

class Gitlab::Project
  include JSON::Serializable
  property path_with_namespace : String
end

class Gitlab::Payload
  include JSON::Serializable
  property project : Project
end
