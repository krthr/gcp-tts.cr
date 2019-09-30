require "base64"

module TTS
  # Convert text to speech and save the result in a .mp3 file.
  #
  # - `text`: Text to convert
  # - `lang`: Language
  # - `path`: Path to the new file
  #
  # Example:
  # ```
  # TTS.authenticate "./credentials.json" # Authenticate
  # TTS.to_file("Hi, how are you?", "en", "./audio.mp3")
  # ```
  #
  def self.to_file(text : String, lang : String, path : String)
    File.write(
      path,
      Base64.decode(
        TTS::Text.synthesize(
          {
            text: text,
            ssml: nil,
          },
          lang
        ).audioContent
      ))
  end
end
