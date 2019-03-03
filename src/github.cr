require "json"

class Repository
  JSON.mapping(
    full_name: String,
  )
end

class Github
  JSON.mapping(
    repository: {type: Repository, nilable: false},
  )
end
