require "spec-kemal"
require "../src/kemal.cr"

describe "Config" do
  it "sets default config file to 'gachette.ini'" do
    Kemal::Config.new.config.should eq Dir.new(Dir.current).path + "/gachette.ini"
  end
  it "sets config to 'gachette.ini.example'" do
    conf = Kemal.config
    conf.config = "gachette.ini.example"
    conf.config.should eq "gachette.ini.example"
  end
  it "adds config option to 'gachette.ini.example'" do
    conf = Kemal.config
    Kemal::CLI.new ["-c", "gachette.ini.example"]
    conf.config.should eq "gachette.ini.example"
  end
end
