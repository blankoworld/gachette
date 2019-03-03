require "spec"
#require "../src/gachette"

def open_json_file(name) : String
  file = File.new(name)
  content = file.gets_to_end || ""
  file.close
  content
end
