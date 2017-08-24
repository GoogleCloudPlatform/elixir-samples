defmodule GettingStartedElixirWeb.PageController do
  use GettingStartedElixirWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: "/books")
  end
end
