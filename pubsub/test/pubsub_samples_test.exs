defmodule GoogleApi.PubSub.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Mock

  @tag :external
  test "create and delete topic" do
    project_id = System.get_env("GOOGLE_PROJECT_ID")
    assert project_id
    topic_name = "test-topic-#{:rand.uniform(100000)}"

    # Create the topic
    output = capture_io(fn ->
      GoogleApi.PubSub.Samples.create_topic(
        project_id,
        topic_name
      )
    end)
    assert String.contains?(
      output,
      "created projects/#{project_id}/topics/#{topic_name}"
    )

    # Delete the topic
    output = capture_io(fn ->
      GoogleApi.PubSub.Samples.delete_topic(
        project_id,
        topic_name
      )
    end)
    assert String.contains?(output, "deleted #{topic_name}")
  end

  test "run supervisor example" do
    start_supervised MockInputAgentGetAndIncrement
    with_mock IO, [:passthrough], [gets: &io_gets/1] do
      output = capture_io(fn -> GoogleApi.PubSub.Samples.run() end)
      # output = GoogleApi.PubSub.Samples.run()
      assert String.contains?(output, "received and acknowledged message")
      assert String.contains?(output, "This is a test pubsub message")
    end
  end

  def io_gets(prompt) do
    case prompt do
      "Project ID?: " -> System.get_env("GOOGLE_PROJECT_ID")
      "Topic Name?: " -> "test-topic"
      "Subscription Name?: " -> "test-subscription"
      "Enter a pubsub message, or (q) to quit: \n" ->
        if MockInputAgentGetAndIncrement.get() == 0 do
          MockInputAgentGetAndIncrement.set(1)
          "This is a test pubsub message\n"
        else
          :timer.sleep(5000);
          "q"
        end
    end
  end
end

defmodule MockInputAgentGetAndIncrement do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get() do
    current_value = Agent.get(__MODULE__, &Map.get(&1, "index")) || 0
    set(current_value + 1)
    current_value
  end

  def set(value) do
    Agent.update(__MODULE__, &Map.put(&1, "index", value))
  end
end