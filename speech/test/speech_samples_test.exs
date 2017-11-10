defmodule GoogleApi.Speech.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @tag :external
  test "transcribe" do
    output = capture_io(fn ->
      GoogleApi.Speech.Samples.recognize(
        "gs://elixir-samples/audio.raw",
        :LINEAR16,
        32000
      )
    end)
    assert String.contains? output, "how old is the Brooklyn Bridge"
  end
end
