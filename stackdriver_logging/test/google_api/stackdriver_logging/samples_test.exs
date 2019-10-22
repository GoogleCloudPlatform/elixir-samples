defmodule GoogleApi.StackdriverLogging.SamplesTest do
  use ExUnit.Case
  doctest GoogleApi.StackdriverLogging.Samples

  test "greets the world" do
    assert GoogleApi.StackdriverLogging.Samples.hello() == :world
  end
end
