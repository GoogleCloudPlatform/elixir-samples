defmodule GoogleApi.BigQuery.Samples do
  @moduledoc """
  Documentation for GoogleApi.BigQuery.Samples.
  """

  # [START bigquery_sync_query]
  @doc """
  List BigQuery buckets for a project.

  ## Examples

      iex> sql = "SELECT TOP(corpus, 10) as title, COUNT(*) as unique_words
                  FROM [publicdata:samples.shakespeare]"
      iex> GoogleApi.BigQuery.Samples.sync_query(project_id, sql)

  """
  def sync_query(project_id, sql) do
    # Fetch access token
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.BigQuery.V2.Connection.new(token.token)

    # Make the API request
    {:ok, response} = GoogleApi.BigQuery.V2.Api.Jobs.bigquery_jobs_query(
      conn,
      project_id,
      [body: %GoogleApi.BigQuery.V2.Model.QueryRequest{ query: sql }]
    )
    response.rows
    |> Enum.each(fn(row) ->
      row.f
      |> Enum.with_index
      |> Enum.each(fn({cell, i}) ->
        IO.puts "#{Enum.at(response.schema.fields, i).name}: #{cell.v}"
      end)
    end)
  end
  # [END bigquery_sync_query]
end
