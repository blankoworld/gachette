require "./spec_helper.cr"
require "../src/gitea.cr"

describe "Gitea" do
  it "repository name is gitea/webhooks" do
    content = open_json_file("spec/push_gitea.json")
    obj = Gitea.from_json(content)
    obj.repository.full_name.should eq "gitea/webhooks"
  end
end
