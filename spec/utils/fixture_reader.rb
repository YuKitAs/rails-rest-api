require "json"

FIXTURE_BASE_PATH = "spec/fixture".freeze

def read_fixture(file)
  return JSON.parse(File.read(File.join(FIXTURE_BASE_PATH, file)))
end
