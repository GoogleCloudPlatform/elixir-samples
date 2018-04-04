defmodule GoogleOAuth2Example.PageControllerTest do
  use GoogleOAuth2Example.ConnCase

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "Google OAuth2 Example Application!"
  end
end
