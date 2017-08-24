defmodule GettingStartedElixir.DatastoreRepo do

  def insert(%{valid?: false} = changeset), do: {:error, changeset}
  def insert(%{data: %{id: id, __meta__: %{source: {_, entity_name}}} = data, changes: changes}) do
    changes
    |> Diplomat.Entity.new(entity_name, id)
    |> Diplomat.Entity.insert

    {:ok, Map.merge(data, changes)}
  end

  def get(mod, id, opts \\ []) do
    Diplomat.Key.new(mod.__schema__(:source), id)
    |> Diplomat.Key.get()
    |> Enum.at(0)
    |> into_struct(mod)
  end

  defp into_struct(%Diplomat.Entity{key: %{name: id}, properties: properties}, mod) do
    data = Enum.map(properties, fn {k, %{value: v}} -> {k, v} end)
    |> Enum.into(%{})
    |> Poison.Decode.decode(as: struct(mod))
    |> Map.put(:id, id)
  end

  def update(%{valid?: false} = changeset), do: {:error, changeset}
  def update(%{data: %{id: id, __meta__: %{source: {_, entity_name}}} = data, changes: changes}) do
    results = data
    |> Map.take(data.__struct__.__schema__(:fields))
    |> Map.merge(changes)

    entity = Diplomat.Entity.new(results, entity_name, id)

    Diplomat.Transaction.begin
    |> Diplomat.Transaction.update(entity)
    |> Diplomat.Transaction.commit

    {:ok, results}
  end

  def delete(%{data: data}), do: delete(data)
  def delete(%{id: id, __meta__: %{source: {_, entity_name}}}) do
    key = Diplomat.Key.new(entity_name, id)

    Diplomat.Transaction.begin
    |> Diplomat.Transaction.delete(key)
    |> Diplomat.Transaction.commit
  end
end
