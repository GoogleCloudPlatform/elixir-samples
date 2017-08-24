defmodule GettingStartedElixirWeb.BookController do
  use GettingStartedElixirWeb, :controller

  alias GettingStartedElixir.{Book, DatastoreRepo}

  def index(conn, _params) do
    books = Book.find_all(10)

    conn
    |> assign(:books, books)
    |> assign(:next_page_token, nil)
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Book.changeset(%Book{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"book" => book_params}) do
    changeset = Book.changeset(%Book{id: UUID.uuid4()}, book_params)

    case DatastoreRepo.insert(changeset) do
      {:ok, book} ->
        conn
        |> redirect(to: book_path(conn, :show, book.id))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end

  end

  def show(conn, %{"id" => id}) do
    book = DatastoreRepo.get(Book, id)

    conn
    |> assign(:book, book)
    |> render("show.html")
  end

  def delete(conn, %{"id" => id}) do
    DatastoreRepo.get(Book, id)
    |> DatastoreRepo.delete()

    conn
    |> redirect(to: book_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    changeset = DatastoreRepo.get(Book, id)
    |> IO.inspect
    |> Book.changeset()

    conn
    |> render("edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    changeset = DatastoreRepo.get(Book, id)
    |> Book.changeset(book_params)

    case DatastoreRepo.update(changeset) do
      {:ok, book} ->
        conn
        |> redirect(to: book_path(conn, :show, book.id))
      {:error, changeset} ->
        conn
        |> render("edit.html", changeset: changeset)
    end
  end
end
