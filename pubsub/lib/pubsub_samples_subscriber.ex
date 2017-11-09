defmodule GoogleApi.PubSub.Samples.Subscriber do
  use Task
  @moduledoc """
  Subscriber sample for GoogleApi.PubSub
  """

  # def init(state), do: {:ok, state}

  def start_link(project_id, subscription_name) do
    task = Task.async(GoogleApi.PubSub.Samples.Subscriber, :listen, [project_id, subscription_name])
    {:ok, task.pid}
  end

  @doc """
  Publish a message to a PubSub topic.

  ## Examples

      iex> GoogleApi.PubSub.Samples.publish("YOUR_PROJECT_ID", "test-topic", "This is a message")
      "published message 159505488737289"

  """
  def listen(project_id, subscription_name) do
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

    if response.receivedMessages != nil do
      Enum.each(response.receivedMessages, fn message ->
        # Acknowledge the message was received
        GoogleApi.PubSub.V1.Api.Projects.pubsub_projects_subscriptions_acknowledge(
          conn,
          project_id,
          subscription_name,
          [body: %GoogleApi.PubSub.V1.Model.AcknowledgeRequest{
            ackIds: [message.ackId]
          }]
        )
        "received and acknowledged message: #{Base.decode64!(message.message.data)}"
        |> (&IO.ANSI.format([:green, :bright, &1])).()
        |> IO.puts
      end)
    end

    listen(project_id, subscription_name)
  end
end