require "json"

module TTS
  module Voice
    # Gender of the voice as described in [SSML voice element](https://www.w3.org/TR/speech-synthesis11/#edef_voice).
    enum SsmlVoiceGender
      # An unspecified gender. In VoiceSelectionParams, this means that the client doesn't care which gender the selected voice will have. In the Voice field of ListVoicesResponse, this may mean that the voice doesn't fit any of the other categories in this enum, or that the gender of the voice isn't known.
      SSML_VOICE_GENDER_UNSPECIFIED
      # A male voice.
      MALE
      # A female voice.
      FEMALE
      # A gender-neutral voice.
      NEUTRAL
    end

    class Voice
      JSON.mapping(
        languageCodes: Array(String),
        name: String,
        ssmlGender: SsmlVoiceGender,
        naturalSampleRateHertz: Float32
      )
    end

    class ListResponse
      JSON.mapping(voices: Array(Voice))
    end

    # Returns a list of Voice supported for synthesis.
    #
    # - `languageCode`: Optional (but recommended) [BCP-47](https://www.rfc-editor.org/rfc/bcp/bcp47.txt) language tag. If specified, the voices.list call will only return voices that can be used to synthesize this languageCode. E.g. when specifying "en-NZ", you will get supported "en-*" voices; when specifying "no", you will get supported "no-*" (Norwegian) and "nb-*" (Norwegian Bokmal) voices; specifying "zh" will also get supported "cmn-*" voices; specifying "zh-hk" will also get supported "yue-*" voices.
    def self.list(languageCode : String? = "") : ListResponse
      response = HTTPClient.get "/voices", {"languageCode" => languageCode}
      ListResponse.from_json response.body
    end
  end
end
