require "spec-kemal"
require "../src/gachette.cr"

describe "Gachette URLs" do
  it "GET '/' \"J'ai la gachette facile !\"" do
    get "/"
    response.body.should eq "" # because we use index.html instead
  end
end
