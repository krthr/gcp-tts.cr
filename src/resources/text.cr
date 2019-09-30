require "json"
require "./voice.cr"

module TTS
  module Text
    enum AudioEncoding
      AUDIO_ENCODING_UNSPECIFIED
      LINEAR16
      MP3
      OGG_OPUS
    end

    class SynthesizeResponse
      JSON.mapping(
        audioContent: String
      )
    end

    alias SynthesisInput = NamedTuple(text: String?, ssml: String?)
    alias VoiceSelectionParams = NamedTuple(languageCode: String, name: String?, ssmlGender: TTS::Voice::SsmlVoiceGender?)
    alias AudioConfig = NamedTuple(audioEncoding: String)
    alias SynthesizeParams = NamedTuple(input: SynthesisInput, voice: VoiceSelectionParams, audioConfig: AudioConfig)

    # Synthesizes speech synchronously: receive results after all text input has been processed.
    #
    # - `input`: Required. The Synthesizer requires either plain text or SSML as input.
    def self.synthesize(
      input : SynthesisInput,
      languageCode = "en",
      ssmlGender : TTS::Voice::SsmlVoiceGender = TTS::Voice::SsmlVoiceGender::SSML_VOICE_GENDER_UNSPECIFIED
    ) : SynthesizeResponse
      req_params = {
        input: input,
        voice: {
          languageCode: languageCode,
          name:         nil,
          ssmlGender:   ssmlGender,
        },
        audioConfig: {
          audioEncoding: "MP3",
        },
      }

      response = HTTPClient.post "/text:synthesize", form: req_params.to_json
      return SynthesizeResponse.from_json response.body
    end
  end
end
