require "json"

class Project
  JSON.mapping(
    path_with_namespace: String,
  )
end

class Gitlab
  JSON.mapping(
    project: {type: Project, nilable: false},
  )
end
