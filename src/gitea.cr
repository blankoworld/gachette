require "json"

class Gitea::Repository
  JSON.mapping(
    full_name: String,
  )
end

class Gitea::Payload
  JSON.mapping(
    repository: {type: Repository, nilable: false},
  )
end
