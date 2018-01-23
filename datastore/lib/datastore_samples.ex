defmodule GoogleApi.Datastore.Samples do

  @moduledoc """
  Documentation for GoogleApi.Datastore.Samples.
  """

  # [START datastore_insert]
  @doc """
  Create a Datastore entity of type "Task"

  ## Examples

      iex> GoogleApi.Datastore.Samples.create_task("Get Milk", "2% is best")

  """
  def create_task(name, description \\ "") do
    Diplomat.Entity.new(
      %{"description" => description},
      "Task",
      name
    ) |> Diplomat.Entity.insert
    :ok
  end
  # [END datastore_insert]

  # [START datastore_query]
  @doc """
  Create a Datastore entity of type "Task"

  ## Examples

      iex> GoogleApi.Datastore.Samples.list_tasks()

  """
  def list_tasks(limit \\ 20) do
    # Run the query
    results = Diplomat.Query.new(
      "select * from `Task` limit @limit",
      %{limit: limit}
    ) |> Diplomat.Query.execute

    # print the results
    Enum.each(results, fn(entity) ->
      name = entity.key.name || entity.key.id
      description = entity.properties["description"].value
      IO.puts "#{name}: #{description}"
    end)
  end
  # [END datastore_query]
end
