defmodule GettingStartedElixir.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "Book" do
    field :title
    field :author
    field :published_date
    field :image_url
    field :description
  end

  def changeset(book, params \\ %{}) do
    book
    |> cast(params, [:title, :author, :published_date, :description])
    |> validate_required([:title, :author, :published_date, :description])
  end

  def find_all(limit), do: find_all(limit, 0)
  def find_all(limit, offset) do
    Diplomat.Query.new(
      "SELECT * FROM `Book` ORDER BY `title` LIMIT @limit OFFSET @offset",
      %{limit: limit, offset: offset}
    ) |> Diplomat.Query.execute
  end

  def find(id) do
    Diplomat.Key.new("Book", id)
    |> Diplomat.Key.get()
    |> Enum.at(0)
  end

end
