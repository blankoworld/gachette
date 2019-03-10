require "json"

class Gitlab::Project
  JSON.mapping(
    path_with_namespace: String,
  )
end

class Gitlab::Payload
  JSON.mapping(
    project: {type: Project, nilable: false},
  )
end
