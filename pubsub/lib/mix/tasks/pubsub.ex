defmodule Mix.Tasks.Pubsub do
  use Mix.Task

  @shortdoc "Runs a simple publish/subscribe example."
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:goth)
    :httpc.set_options(pipeline_timeout: 1000)
    project_id = get_response("Project ID?: ")
    topic_name = get_response("Topic Name?: ")
    topic = get_or_create_topic(project_id, topic_name)
    if topic do
      subscription_name = get_response "Subscription Name?: "
      subscription = get_or_create_subscription(project_id, topic_name, subscription_name)
      if subscription do
        {:ok, _pid} = GoogleApi.PubSub.Samples.start_subscription_supervisor(project_id, subscription_name)
        get_next_message(project_id, topic_name)
      end
    end
  end

  defp get_or_create_topic(project_id, topic_name) do
    GoogleApi.PubSub.Samples.get_topic(project_id, topic_name) ||
      (confirm_topic_creation() && GoogleApi.PubSub.Samples.create_topic(project_id, topic_name))
  end

  defp confirm_topic_creation do
    get_response("Topic does not exist. Create it? (y/n): ")
    |> case do
      "y" -> true
      _ -> nil
    end
  end

  defp get_or_create_subscription(project_id, topic_name, subscription_name) do
    GoogleApi.PubSub.Samples.get_subscription(project_id, subscription_name) ||
      (confirm_subscription_creation() && GoogleApi.PubSub.Samples.create_subscription(project_id, topic_name, subscription_name))
  end

  defp confirm_subscription_creation do
    get_response("Subscription does not exist. Create it? (y/n): ")
    |> case do
      "y" -> true
      _ -> nil
    end
  end

  defp get_next_message(project_id, topic_name) do
    message = get_response("Enter a pubsub message, or (q) to quit: \n")
    if !Enum.member?(["q", ""], message) do
      GoogleApi.PubSub.Samples.publish(project_id, topic_name, message)
      get_next_message(project_id, topic_name)
    end
  end

  defp get_response(prompt) do
    prompt |> IO.gets() |> String.trim("\n")
  end
end
