defmodule GoogleApi.PubSub.Samples do
  @moduledoc """
  Documentation for GoogleApi.PubSub.Samples.
  """

  @doc """
  Create a PubSub topic.

  ## Examples

      iex> GoogleApi.PubSub.Samples.create_topic("YOUR_PROJECT_ID", "test-topic")
      "created projects/YOUR_PROJECT_ID/topcs/test-topic"

  """
  def create_topic(project_id, topic_name) do
    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.token)

    # Make the API request.
    {:ok, response} = GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_topics_create(
      conn,
      project_id,
      topic_name,
      [body: %{}] # "body" cannot be nil for POST/PUT/PATH/DELETE in httpc
    )

    "created #{response.name}"
  end

  @doc """
  Delete a PubSub topic.

  ## Examples

      iex> GoogleApi.PubSub.Samples.delete_topic("YOUR_PROJECT_ID", "test-topic")
      "deleted projects/YOUR_PROJECT_ID/topcs/test-topic"

  """
  def delete_topic(project_id, topic_name) do
    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.token)

    # Make the API request.
    {:ok, %GoogleApi.PubSub.V1.Model.Empty{}} = GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_topics_delete(
      conn,
      project_id,
      topic_name
    )

    "deleted #{topic_name}"
  end
end
