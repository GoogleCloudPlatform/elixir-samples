defmodule GoogleOAuth2Example.PageController do
  use GoogleOAuth2Example.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
