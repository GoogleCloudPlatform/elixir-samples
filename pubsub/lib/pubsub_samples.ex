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
        :topic => "projects/#{project_id}/topics/#{topic_name}"
      }]
    )

    "created subscription #{response.name} on topic #{response.pushConfig.topic}"
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

    IO.puts("published message #{response.messageIds}")
  end

  def subscriber_listen(project_id, subscription_name) do
    {:ok, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    conn = GoogleApi.PubSub.V1.Connection.new(token.token)

    # Make a subscription pull
    {:ok, response} = GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_subscriptions_pull(
      conn,
      project_id,
      subscription_name,
      [body: %GoogleApi.PubSub.V1.Model.PullRequest{
        maxMessages: 10
      }]
    )

    for message <- response.receivedMessages do
      # Acknowledge the message was received
      GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_subscriptions_acknowledge(
        conn,
        project_id,
        subscription_name,
        [body: %GoogleApi.PubSub.V1.Model.AcknowledgeRequest{
          ackIds: [message.ackId]
        }]
      )
      IO.puts("received and acknowledged message: #{Base.decode64!(message.message.data)}")
    end
  end

  @doc """
  Creates a subscription process and publishes a message to it.

  ## Examples

      iex> GoogleApi.PubSub.Samples.async_publish_and_subscribe(
        "YOUR_PROJECT_ID",
        "test-topic",
        "test-subscription",
        "This is a message"
      )
      "published message 159505488737289"
      "received and acknowledged message: This is a message

  """
  def async_publish_and_subscribe(project_id, topic_name, subscription_name, message) do
    publish(project_id, topic_name, message)
    spawn(GoogleApi.PubSub.Samples, :subscriber_listen, [project_id, subscription_name])
  end
end
