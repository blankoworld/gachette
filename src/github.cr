require "json"

class Github::Repository
  JSON.mapping(
    full_name: String,
  )
end

class Github::Payload
  JSON.mapping(
    repository: {type: Repository, nilable: false},
  )
end
