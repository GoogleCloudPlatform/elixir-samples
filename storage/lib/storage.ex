defmodule GoogleApi.Storage.Samples do
  require Tesla

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
    print_buckets(response.items)
    "done!"
  end

  defp print_buckets([bucket|buckets]) do
    IO.puts bucket.id
    print_buckets(buckets)
  end
  defp print_buckets([]), do: nil
end
