defmodule GoogleApi.Storage.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest GoogleApi.Storage.Samples, except: [:moduledoc, list_buckets: 1]

  test "lists buckets" do
    project_id = System.get_env("GOOGLE_PROJECT_ID")
    assert project_id
    output = capture_io(fn ->
        GoogleApi.Storage.Samples.list_buckets(project_id)
    end)
    assert String.contains? output, project_id
  end
end
