defmodule Mix.Tasks.Pubsub do
  use Mix.Task

  @shortdoc "Runs a simple publish/subscribe example."
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:goth)
    :httpc.set_options(pipeline_timeout: 1000)

    project_id = (IO.gets "Project ID?: ")
        |> String.trim("\n")
    topic_name = (IO.gets "Topic Name?: ")
        |> String.trim("\n")

    topic = get_or_create_topic(project_id, topic_name)

    if topic do
        subscription_name = (IO.gets "Subscription Name?: ")
            |> String.trim("\n")
        subscription = get_or_create_subscription(project_id, topic_name, subscription_name)

        if subscription do
            {:ok, pid} = GoogleApi.PubSub.Samples.start_subscription_supervisor(project_id, subscription_name)
            get_next_message(project_id, topic_name)
        end
    end
  end

  defp get_or_create_topic(project_id, topic_name) do
    topic = GoogleApi.PubSub.Samples.get_topic(project_id, topic_name)
    if topic == nil do
        response = (IO.gets "Topic does not exist. Create it? (y/n): ")
            |> String.trim("\n")
        if response == "y" do
            GoogleApi.PubSub.Samples.create_topic(project_id, topic_name)
        end
    else
        topic
    end
  end

  defp get_or_create_subscription(project_id, topic_name, subscription_name) do
    subscription = GoogleApi.PubSub.Samples.get_subscription(project_id, subscription_name)
    if subscription == nil do
        response = (IO.gets "Subscription does not exist. Create it? (y/n): ")
            |> String.trim("\n")
        if response == "y" do
            GoogleApi.PubSub.Samples.create_subscription(project_id, topic_name, subscription_name)
        end
    else
        subscription
    end
  end

  defp get_next_message(project_id, topic_name) do
    message = (IO.gets "Enter a pubsub message, or (q) to quit: ")
        |> String.trim("\n")
    if !Enum.member?(["q", ""], message) do
        GoogleApi.PubSub.Samples.publish(project_id, topic_name, message)
        get_next_message(project_id, topic_name)
    end
  end
end