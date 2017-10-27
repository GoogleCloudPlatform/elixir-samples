defmodule GoogleApi.BigQuery.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "execute sql synchronously" do
    project_id = System.get_env("GOOGLE_PROJECT_ID")
    assert project_id
    output = capture_io(fn ->
        sql = "SELECT TOP(corpus, 10) as title, COUNT(*) as unique_words
                FROM [publicdata:samples.shakespeare]"
        GoogleApi.BigQuery.Samples.sync_query(project_id, sql)
    end)
    assert String.contains? output, "hamlet"
  end
end
