defmodule Mix.Tasks.Pubsub do
  use Mix.Task

  @shortdoc "Runs a simple publish/subscribe example."
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:goth)
    :httpc.set_options(pipeline_timeout: 1000)
    project_id =
      "Project ID?: "
      |> IO.gets()
      |> String.trim("\n")
    topic_name =
      "Topic Name?: "
      |> IO.gets()
      |> String.trim("\n")
    topic = get_or_create_topic(project_id, topic_name)
    if topic do
      subscription_name =
        "Subscription Name?: "
        |> IO.gets()
        |> String.trim("\n")
      subscription = get_or_create_subscription(project_id, topic_name, subscription_name)
      if subscription do
        {:ok, _pid} = GoogleApi.PubSub.Samples.start_subscription_supervisor(project_id, subscription_name)
        get_next_message(project_id, topic_name)
      end
    end
  end

  defp get_or_create_topic(project_id, topic_name) do
    GoogleApi.PubSub.Samples.get_topic(project_id, topic_name) ||
      (confirm_topic_creation() && GoogleApi.PubSub.Samples.create_topic(project_id, topic_name)
  end

  defp confirm_topic_creation do
    "Topic does not exist. Create it? (y/n): "
    |> IO.gets()
    |> String.trim("\n")
    |> case do
      "y" -> true
      _ -> nil
    end
  end

  defp get_or_create_subscription(project_id, topic_name, subscription_name) do
    GoogleApi.PubSub.Samples.get_subscription(project_id, subscription_name) ||
      (confirm_subscription_creation() && GoogleApi.PubSub.Samples.create_subscription(project_id, topic_name, subscription_name)
  end

  defp confirm_subscription_creation do
    "Subscription does not exist. Create it? (y/n): "
    |> IO.gets()
    |> String.trim("\n")
    |> case do
      "y" -> true
      _ -> nil
    end
  end

  defp get_next_message(project_id, topic_name) do
    message =
      "Enter a pubsub message, or (q) to quit: "
      |> IO.gets()
      |> String.trim("\n")
    if !Enum.member?(["q", ""], message) do
      GoogleApi.PubSub.Samples.publish(project_id, topic_name, message)
      get_next_message(project_id, topic_name)
    end
  end
end
