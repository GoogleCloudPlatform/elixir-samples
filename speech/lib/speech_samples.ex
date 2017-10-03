defmodule GoogleApi.Speech.Samples do
  @moduledoc """
  Documentation for GoogleApi.Speech.Samples.
  """

  @doc """
  Transcribe text from an audio file.

  ## Examples

      GoogleApi.Speech.Samples.recognize("gs://elixir-samples/audio.raw", :LINEAR16, 16000)
      how old is the Brooklyn Bridge
      "done!"

  """
  def recognize(audio_uri, encoding, sampleRateHertz, languageCode \\ "en_US") do
    # Build the RecognizeRequest struct
    request = %GoogleApi.Speech.V1.Model.RecognizeRequest{
      audio: %GoogleApi.Speech.V1.Model.RecognitionAudio{uri: audio_uri},
      config: %GoogleApi.Speech.V1.Model.RecognitionConfig{
        encoding:  encoding,
        sampleRateHertz: sampleRateHertz,
        languageCode: "en_US"
      }
    }

    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.Speech.V1.Connection.new(token.token)

    # Make the API request.
    {:ok, response} = GoogleApi.Speech.V1.Api.Speech.speech_speech_recognize(
      conn,
      [body: request]
    )

    # Print the results.
    Enum.each(response.results, fn(result) ->
      Enum.each(result.alternatives, fn(alt) ->
        IO.puts(alt.transcript)
      end)
    end)
    "done!"
  end
end
