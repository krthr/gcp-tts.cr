require "jwt"
require "json"
require "crest"

module TTS
  # - `json_path`: Path to the credentials json file
  def self.authenticate(
    json_path : String
  )
    config = JSON.parse(File.read(json_path))

    TTS::HTTPClient.set_credentials config["client_email"].to_s, config["private_key"].to_s
    TTS::HTTPClient.authenticate
  end
end
