defmodule GoogleApi.Storage.Samples do
  @moduledoc """
  Documentation for GoogleApi.Storage.Samples.
  """

  @doc """
  List storage buckets for a project.

  ## Examples

      iex> GoogleApi.Storage.Samples.list_buckets("your_project_id")
      your_project_bucket1
      your_project_bucket2

  """
  def list_buckets(project_id) do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.Storage.V1.Connection.new(token.token)
    {:ok, response} = GoogleApi.Storage.V1.Api.Buckets.storage_buckets_list(conn, project_id)
    Enum.each(response.items, &IO.puts(&1.id))
  end

  # [START storage_upload_file]
  @doc """
  List storage buckets for a project.

  ## Examples

      iex> GoogleApi.Storage.Samples.upload_file("bucket_id", "test/file.txt")
      Uploaded file.text to  https://www.googleapis.com/storage/v1/b/bucket_id/o/file.txt
      your_project_bucket2

  """
  def upload_file(bucket_id, file_path) do
    # Authenticate.
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.Storage.V1.Connection.new(token.token)

    # Make the API request.
    {:ok, object} = GoogleApi.Storage.V1.Api.Objects.storage_objects_insert_simple(
      conn,
      bucket_id,
      "multipart",
      %{name: Path.basename(file_path)},
      file_path
    )

    # Print the object.
    IO.puts("Uploaded #{object.name} to #{object.selfLink}")
  end
  # [END storage_upload_file]
end
