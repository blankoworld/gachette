require "./spec_helper.cr"
require "../src/gitea.cr"

describe "Gitea JSON result" do
  it "repository name is 'gitea/webhooks'" do
    content = open_json_file("spec/push_gitea.json")
    obj = Gitea::Payload.from_json(content)
    obj.repository.full_name.should eq "gitea/webhooks"
  end

  it "secret is '3gEsCfjlV2ugRwgpU#w1*WaW*wa4NXgGmpCfkbG3'" do
    content = open_json_file("spec/push_gitea.json")
    obj = Gitea::Payload.from_json(content)
    obj.secret.should eq "3gEsCfjlV2ugRwgpU#w1*WaW*wa4NXgGmpCfkbG3"
  end
end
