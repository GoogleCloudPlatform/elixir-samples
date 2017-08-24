defmodule GettingStartedElixirWeb.BookView do
  use GettingStartedElixirWeb, :view

  def book_title(%{properties: %{"title" => %{value: title}}}), do: title
  def book_title(%{title: title}), do: title
  def book_title(_), do: "Unknown"

  def book_published_date(%{properties: %{"published_date" => %{value: date}}}), do: date
  def book_published_date(%{published_date: date}), do: date
  def book_published_date(_), do: "Unknown"

  def book_author(%{properties: %{"author" => %{value: author}}}), do: author
  def book_author(%{author: author}), do: author
  def book_author(_), do: "Unknown"

  def book_description(%{properties: %{"description" => %{value: description}}}), do: description
  def book_description(%{description: description}), do: description
  def book_description(_), do: "Unknown"
end
