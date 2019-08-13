require "spec-kemal"
require "../src/kemal.cr"

describe "Config" do
  it "sets default kind to 'github'" do
    Kemal::Config.new.kind.should eq "github"
  end
  it "sets default namespace to 'blankoworld/gachette'" do
    Kemal::Config.new.namespace.should eq "blankoworld/gachette"
  end
  it "sets default secretkey to empty string" do
    Kemal::Config.new.secretkey.should eq ""
  end
  it "sets command to 'ls /'" do
    conf = Kemal.config
    conf.command = "ls /"
    conf.command.should eq "ls /"
  end
  it "sets scriptfile to './my_script.sh'" do
    conf = Kemal.config
    conf.scriptfile = "./my_script.sh"
    conf.scriptfile.should eq "./my_script.sh"
  end
  it "adds kind option to 'something'" do 
    conf = Kemal.config
    Kemal::CLI.new ["-k", "something"]
    conf.kind.should eq "something"
  end
  it "adds name option to 'olivier/gachette'" do
    conf = Kemal.config
    Kemal::CLI.new ["-n", "olivier/gachette"]
    conf.namespace.should eq "olivier/gachette"
  end
  it "adds command option to 'ls /'" do
    conf = Kemal.config
    Kemal::CLI.new ["-c", "ls /"]
    conf.command.should eq "ls /"
  end
  # TODO: Check 'scriptfile' option
end
