defmodule GoogleApi.Datastore.Samples.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "create and list tasks" do
    name = "Get Milk on #{DateTime.utc_now}"
    return = GoogleApi.Datastore.Samples.create_task(name, "It better be 2% or higher")
    assert return == :ok
    output = capture_io(fn ->
      GoogleApi.Datastore.Samples.list_tasks()
    end)
    assert String.contains? output, name
  end
end
