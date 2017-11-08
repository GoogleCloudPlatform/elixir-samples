defmodule GoogleApi.PubSub.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

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
end
