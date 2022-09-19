require "spec-kemal"
require "./spec_helper.cr"
require "../src/kemal.cr"

describe "Payload object" do
  it "creates a payload GITEA object" do
    body = open_json_file("spec/push_gitea.json")
    request = HTTP::Request.new(
      "POST",
      "/",
      body: body,
      headers: GITEA_HEADERS,
    )
    payload = Payload.new request
    payload.kind.should eq "gitea"
    payload.content.should eq GITEA_PAYLOAD
    payload.secret.should eq "d58246075b9c1ac31282034c565ec186ce229775572f5177086636d4c71d1c91"
    payload.project.should eq "gitea/webhooks"
  end

  it "creates a payload GITLAB object" do
    body = open_json_file("spec/push_gitlab.json")
    request = HTTP::Request.new(
      "POST",
      "/",
      body: body,
      headers: GITLAB_HEADERS,
    )
    payload = Payload.new request
    payload.kind.should eq "gitlab"
    payload.content.should eq body
    payload.secret.should eq "mot2passe"
    payload.project.should eq "mike/diaspora"
  end

  it "creates a payload GITHUB object" do
    request = HTTP::Request.new(
      "POST",
      "/",
      body: GITHUB_PAYLOAD,
      headers: GITHUB_HEADERS,
    )
    payload = Payload.new request
    payload.kind.should eq "github"
    payload.content.should eq GITHUB_PAYLOAD
    payload.secret.should eq "sha1=8cfbbbf7a0b7b8322519ac7fbf346ad9a9475236"
    payload.project.should eq "blankoworld/gachette"
  end
end
