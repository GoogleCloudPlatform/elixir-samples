defmodule GoogleApi.PubSub.Samples.Test do
  use ExUnit.Case

  @tag :external
  test "create and delete topic" do
    project_id = System.get_env("GOOGLE_PROJECT_ID")
    assert project_id
    topic_name = "test-topic-#{:rand.uniform(100000)}"

    # Create the topic
    result = GoogleApi.PubSub.Samples.create_topic(
      project_id,
      topic_name
    )
    assert String.contains?(
      result,
      "created projects/#{project_id}/topics/#{topic_name}"
    )

    # Delete the topic
    result = GoogleApi.PubSub.Samples.delete_topic(
      project_id,
      topic_name
    )
    assert String.contains?(result, "deleted #{topic_name}")
  end
end
