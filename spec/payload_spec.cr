require "spec-kemal"
require "./spec_helper.cr"
require "../src/kemal.cr"

describe "Payload object" do
  it "creates a payload GITEA object" do
    headers = HTTP::Headers{
      "User-Agent"        => "GiteaServer",
      "Content-Type"      => "application/json",
      "X-GitHub-Delivery" => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
      "X-GitHub-Event"    => "push",
      "X-Gitea-Delivery"  => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
      "X-Gitea-Event"     => "push",
      "X-Gogs-Delivery"   => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
      "X-Gogs-Event"      => "push             ",
    }
    body = open_json_file("spec/push_gitea.json")
    request = HTTP::Request.new(
      "POST",
      "/",
      body: body,
      headers: headers,
    )
    payload = Payload.new request
    payload.kind.should eq "gitea"
    payload.content.should eq body
    payload.secret.should eq "3gEsCfjlV2ugRwgpU#w1*WaW*wa4NXgGmpCfkbG3"
    payload.project.should eq "gitea/webhooks"
  end

  it "creates a payload GITLAB object" do
    headers = HTTP::Headers{
      "Content-Type"   => "application/json",
      "X-Gitlab-Event" => "Push Hook",
      "X-Gitlab-Token" => "mot2passe",
    }
    body = open_json_file("spec/push_gitlab.json")
    request = HTTP::Request.new(
      "POST",
      "/",
      body: body,
      headers: headers,
    )
    payload = Payload.new request
    payload.kind.should eq "gitlab"
    payload.content.should eq body
    payload.secret.should eq "mot2passe"
    payload.project.should eq "mike/diaspora"
  end

  it "creates a payload GITHUB object" do
    headers = HTTP::Headers{
      "content-type"      => "application/json",
      "Expect"            => "",
      "User-Agent"        => "GitHub-Hookshot/hashsah",
      "X-GitHub-Delivery" => "691df212-bdb7-11e9-8119-fa2f1de358a6",
      "X-GitHub-Event"    => "push",
      "X-Hub-Signature"   => "sha1=8cfbbbf7a0b7b8322519ac7fbf346ad9a9475236",
    }
    body = GITHUB_PAYLOAD
    request = HTTP::Request.new(
      "POST",
      "/",
      body: body,
      headers: headers,
    )
    payload = Payload.new request
    payload.kind.should eq "github"
    payload.content.should eq body
    payload.secret.should eq "sha1=8cfbbbf7a0b7b8322519ac7fbf346ad9a9475236"
    payload.project.should eq "blankoworld/gachette"
  end
end
