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
    "done!"
  end
end
