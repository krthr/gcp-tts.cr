# Google Cloud - Text-To-Speech

Unofficial Google Cloud TTS API client.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     gcp-tts:
       github: krthr/gcp-tts.cr
   ```

2. Run `shards install`

## Usage

### First of all, you need to authenticate client with the service user credentials .json file
```crystal
require "gcp-tts"

TTS.authenticate "./credentials.json"
```

### Get a list of Voice supported for synthesis.
```crystal
puts TTS::Voice.list
puts TTS::Voice.list "en" # using language tag
```

### Get a Base64 representation of a .MP3 file 
```crystal
result = TTS::Text.synthesize(
  { 
    text: "I'm in love with Crystal"
    #ssml: "" #  or using ssml
  }, 
  "en" # lang code
)

puts result.audioContent # Base64 result
```

### Save an .MP3 file with the result
```crystal
TTS.to_file("¡Hola!", "es", "./audio.mp3")
```

## Development :D

## Contributing

1. Fork it (<https://github.com/krthr/gcp-tts.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [krthr](https://github.com/gcp-tts.cr) - creator and maintainer
