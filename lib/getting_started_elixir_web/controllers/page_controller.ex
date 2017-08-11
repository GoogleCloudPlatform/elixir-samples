defmodule GettingStartedElixirWeb.PageController do
  use GettingStartedElixirWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
