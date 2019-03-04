require "spec-kemal"
require "../src/gachette.cr"

describe "Gachette" do
  it "récupération de /" do
    get "/"
    response.body.should eq "J'ai la gachette facile !"
  end

end
