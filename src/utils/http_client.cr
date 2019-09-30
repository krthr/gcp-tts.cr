require "crest"
require "json"

module TTS
  # :nodoc:
  module HTTPClient
    @@client : Crest::Resource?
    @@access_token : String?
    @@token : String?
    @@time_unix : Int64?

    @@client_email : String = ""
    @@private_key : String = ""

    def self.set_credentials(client_email : String, private_key : String)
      @@client_email = client_email
      @@private_key = private_key
    end

    def self.authenticate
      self.get_jwt
      self.get_access_token
      self.init_client
    end

    def self.get(path : String, params = {} of String => String)
      if @@time_unix.as(Int64) < (Time.local + 1.hour).to_unix
        self.authenticate
      end

      @@client.as(Crest::Resource).get(path, params: params)
    end

    def self.post(path : String, form = {} of String => String, params = {} of String => String)
      if @@time_unix.as(Int64) < (Time.local + 1.hour).to_unix
        self.authenticate
      end

      @@client.as(Crest::Resource).post(path, form: form, params: params)
    end

    # Inititalize the HTTP Client with the token
    private def self.init_client
      @@client = Crest::Resource.new(
        "https://texttospeech.googleapis.com/v1",
        headers: {"Authorization" => "Bearer #{@@access_token}"}
      )
    end

    # Get the Google Access Token
    private def self.get_access_token
      response = Crest.post "https://oauth2.googleapis.com/token", form: {
        "grant_type" => "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "assertion"  => @@token,
      }

      @@access_token = JSON.parse(response.body)["access_token"].as_s
    end

    # Get token
    private def self.get_jwt
      time = Time.local
      @@time_unix = time.to_unix
      @@token = JWT.encode(
        {
          "iss"   => @@client_email,
          "scope" => "https://www.googleapis.com/auth/cloud-platform",
          "aud"   => "https://oauth2.googleapis.com/token",
          "exp"   => (time + 1.hour).to_unix,
          "iat"   => time.to_unix,
        },
        @@private_key,
        JWT::Algorithm::RS256
      )
    end

    # /v1/text:synthesize
    # /v1/voices
  end
end
