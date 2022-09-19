require "spec-kemal"
require "../src/gachette.cr"
require "./spec_helper.cr"

describe "Gachette URLs" do
  it "GET '/' \"J'ai la gachette facile !\"" do
    get "/"
    response.status_code.should eq 302
    response.body.should eq "" # because we use index.html instead
  end

  it "POST '/' with well-formed GITEA backend" do
    json_payload = open_json_file("spec/push_gitea.json")
    post("/", GITEA_HEADERS, GITEA_PAYLOAD)
    response.body.should eq("SUCCESS")
  end

  it "POST '/' with well-formed GITLAB backend" do
    json_payload = open_json_file("spec/push_gitlab.json")
    post("/", GITLAB_HEADERS, json_payload)
    response.body.should eq("SUCCESS")
  end

  it "POST '/' with well-formed GITHUB backend" do
    post("/", GITHUB_HEADERS, GITHUB_PAYLOAD)
    response.body.should eq("SUCCESS")
  end
end
