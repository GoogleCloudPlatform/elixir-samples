defmodule GoogleOAuth2Example.AuthController do
  use GoogleOAuth2Example.Web, :controller

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  Google's OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code, "state" => state}) when is_binary(state) do
    if conn |> get_session(:state) != state do
      raise "state parameter is invalid."
    end

    # Exchange an auth code for an access token
    client = Google.get_token!(code: code)

    # Request the user's data with the access token
    scope = "https://www.googleapis.com/plus/v1/people/me/openIdConnect"
    %{body: user} = OAuth2.Client.get!(client, scope)
    current_user = %{
      name: user["name"],
      avatar: String.replace_suffix(user["picture"], "?sz=50", "?sz=400")
    }

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, current_user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth` and redirects to the Google OAuth2 provider.
  """
  def index(conn, _params) do
    conn
    |> set_state()
    |> redirect_to_authrization_url()
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp set_state(conn) do
    case conn |> get_session(:state) do
      nil ->
        state = :crypto.strong_rand_bytes(32) |> Base.encode64 |> binary_part(0, 32)
        conn |> put_session(:state, state)
      _ -> conn
    end
  end

  defp redirect_to_authrization_url(conn) do
    conn
    |> redirect( external: Google.authorize_url!(
      state: conn |> get_session(:state),
      scope: "https://www.googleapis.com/auth/userinfo.email"
    ))
  end
end
