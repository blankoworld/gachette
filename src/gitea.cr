require "json"

class Gitea::Repository
  include JSON::Serializable
  property full_name : String
end

class Gitea::Payload
  include JSON::Serializable
  property repository : Repository
  property secret : String
end
