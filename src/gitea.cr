require "json"

class Repository
  JSON.mapping(
    full_name: String,
  )
end

class Gitea
  JSON.mapping(
    repository: {type: Repository, nilable: false},
  )
end
