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
    # Trust me, you need configuration!
    reset_kemal_config
    conf = Kemal.config
    conf.secretkey = "3gEsCfjlV2ugRwgpU#w1*WaW*wa4NXgGmpCfkbG3"

    Kemal::CLI.new ["-k", "gitea", "-n", "gitea/webhooks", "-c", "ls /"]

    json_payload = open_json_file("spec/push_gitea.json")
    post("/", HTTP::Headers{
        "User-Agent"        => "GiteaServer",
        "Content-Type"      => "application/json",
        "X-GitHub-Delivery" => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
        "X-GitHub-Event"    => "push",
        "X-Gitea-Delivery"  => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
        "X-Gitea-Event"     => "push",
        "X-Gogs-Delivery"   => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
        "X-Gogs-Event"      => "push             ",
      }, json_payload)
    response.body.should eq("SUCCESS")
  end

  it "POST '/' with well-formed GITLAB backend" do
    # Trust me, you need configuration!
    reset_kemal_config
    conf = Kemal.config
    conf.secretkey = "mot2passe"

    Kemal::CLI.new ["-k", "gitlab", "-n", "mike/diaspora", "-c", "ls /"]

    json_payload = open_json_file("spec/push_gitlab.json")
    post("/", HTTP::Headers{
        "Content-Type"      => "application/json",
        "X-Gitlab-Event"    => "Push Hook",
        "X-Gitlab-Token"      => "mot2passe",
      }, json_payload)
    response.body.should eq("SUCCESS")
  end

  it "POST '/' with well-formed GITHUB backend" do
    # Trust me, you need configuration!
    reset_kemal_config
    conf = Kemal.config
    conf.secretkey = "quelquechose"

    Kemal::CLI.new ["-k", "github", "-n", "blankoworld/gachette", "-c", "ls /"]

    json_payload = GITHUB_PAYLOAD
    post("/", HTTP::Headers{
      "content-type"      => "application/json",
      "Expect"            => "",
      "User-Agent"        => "GitHub-Hookshot/hashsah",
      "X-GitHub-Delivery" => "691df212-bdb7-11e9-8119-fa2f1de358a6",
      "X-GitHub-Event"    => "push",
      "X-Hub-Signature"   => "sha1=8cfbbbf7a0b7b8322519ac7fbf346ad9a9475236",
      }, json_payload)
    response.body.should eq("SUCCESS")
  end
end
