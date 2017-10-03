defmodule GoogleApi.Speech.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest GoogleApi.Speech.Samples

  test "transcribe" do
    output = capture_io(fn ->
        GoogleApi.Speech.Samples.recognize(
          "gs://elixir-samples/audio.raw",
          :LINEAR16,
          16000
        )
    end)
    assert String.contains? output, "how old is the Brooklyn Bridge"
  end
end
