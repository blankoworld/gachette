require "./spec_helper.cr"
require "../src/gitlab.cr"

describe "Gitlab" do
  it "repository name is mike/diaspora" do
    content = open_json_file("spec/push_gitlab.json")
    obj = Gitlab::Payload.from_json(content)
    obj.project.path_with_namespace.should eq "mike/diaspora"
  end
end
