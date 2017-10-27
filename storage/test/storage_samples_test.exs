defmodule GoogleApi.Storage.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "lists buckets" do
    project_id = System.get_env("GOOGLE_PROJECT_ID")
    assert project_id
    output = capture_io(fn ->
      GoogleApi.Storage.Samples.list_buckets(project_id)
    end)
    assert String.contains? output, project_id
  end

  test "upload object" do
    # Use the project ID as the bucket ID
    bucket_id = System.get_env("GOOGLE_PROJECT_ID")
    assert bucket_id
    output = capture_io(fn ->
      GoogleApi.Storage.Samples.upload_file(bucket_id, "test/data/file.txt")
    end)
    assert String.contains? output, "Uploaded file.txt to https://www.googleapis.com/storage/v1/b/#{bucket_id}/o/file.txt"
  end
end
