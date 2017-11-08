defmodule GoogleApi.PubSub.Samples do
  @moduledoc """
  Documentation for GoogleApi.PubSub.Samples.
  """

  @doc """
  Get a PubSub topic.

  ## Examples

      iex> GoogleApi.PubSub.Samples.get_topic("YOUR_PROJECT_ID", "test-topic")

  """
  def get_topic(project_id, topic_name) do
    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.token)

    # Make the API request.
    response = GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_topics_get(
      conn,
      project_id,
      topic_name
    )

    case response do
      {:ok, topic} -> topic
      {:error, _} -> nil
    end
  end

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

    IO.puts "created #{response.name}"
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

    IO.puts "deleted #{topic_name}"
  end

  @doc """
  Get a PubSub subscription.

  ## Examples

      iex> GoogleApi.PubSub.Samples.get_subscription("YOUR_PROJECT_ID", "test-subscription")

  """
  def get_subscription(project_id, subscription_name) do
    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.token)

    # Make the API request.
    response = GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_subscriptions_get(
      conn,
      project_id,
      subscription_name
    )

    case response do
      {:ok, subscription} -> subscription
      {:error, _} -> nil
    end
  end

  @doc """
  Subscribe to a PubSub topic, print the message on push.

  ## Examples

      iex> GoogleApi.PubSub.Samples.create_subscription("YOUR_PROJECT_ID", "test-topic", "test-subscription")
      "created subscription projects/YOUR_PROJECT_ID/subscriptions/test-subscription on topic projects/YOUR_PROJECT_ID/subscriptions/test-topic"

  """
  def create_subscription(project_id, topic_name, subscription_name) do
    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.token)

    # Make the API request.
    {:ok, response} = GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_subscriptions_create(
      conn,
      project_id,
      subscription_name,
      [body: %{
        topic: "projects/#{project_id}/topics/#{topic_name}"
      }]
    )

    IO.puts "created subscription #{response.name} on topic #{response.name}"
  end

  @doc """
  Publish a message to a PubSub topic.

  ## Examples

      iex> GoogleApi.PubSub.Samples.publish("YOUR_PROJECT_ID", "test-topic", "This is a message")
      "published message 159505488737289"

  """
  def publish(project_id, topic_name, message) do
    # Authenticate
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.token)

    # Build the PublishRequest struct
    request = %GoogleApi.PubSub.V1.Model.PublishRequest{
      messages: [
        %GoogleApi.PubSub.V1.Model.PubsubMessage{
          data: Base.encode64(message)
        }
      ]
    }

    # Make the API request.
    {:ok, response} = GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_topics_publish(
      conn,
      project_id,
      topic_name,
      [body: request]
    )

    "published message #{response.messageIds}"
    |> (&IO.ANSI.format([:green, :bright, &1], true)).()
    |> IO.puts
  end

  def start_subscription_supervisor(project_id, subscription_name) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the worker when the application starts
      supervisor(GoogleApi.PubSub.Samples.Subscriber, [project_id, subscription_name]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GoogleApi.PubSub.Samples.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
