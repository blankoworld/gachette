require "json"

class Github::Repository
  include JSON::Serializable
  property full_name : String
end

class Github::Payload
  include JSON::Serializable
  property repository : Repository
end
