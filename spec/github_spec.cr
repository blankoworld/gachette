require "./spec_helper.cr"
require "../src/github.cr"

describe "Github" do
  it "repository name is Codertocat/Hello-World" do
    content = open_json_file("spec/push_github.json")
    obj = Github::Payload.from_json(content)
    obj.repository.full_name.should eq "Codertocat/Hello-World"
  end
end
