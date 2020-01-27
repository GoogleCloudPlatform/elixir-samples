# Google OAuth2 with Phoenix Example Application

> This is an example application based off the
> [OAuth2 Example Application](https://github.com/scrogson/oauth2_example)
> showing how one can use 3-legged
> [OAuth](https://developers.google.com/identity/protocols/OAuth2) for Google using
> the [Phoenix](https://github.com/phoenixframework/phoenix) framework and the
> [OAuth2](https://github.com/scrogson/oauth2) library.

![Alt text](https://storage.googleapis.com/elixir-auth.appspot.com/google-oauth-phoenix.png)

### Try the demo out at [https://elixir-auth.appspot.com](https://elixir-auth.appspot.com)!

## Run the Application

To start the application:

1. Register a new application in the [Google Developer Console](https://console.developers.google.com/apis/credentials)
    - Click `Create Credentials` > `OAuth client ID`
    - Select "Web application" as the application type
    - Enter http://localhost:4000/auth/callback as an authorized redirect URI
    - Click `Dashboard` > `ENABLE APIS AND SERVICES` and enable "Google+ API"
2. Set the `GOOGLE_REDIRECT_URI` environment variable to the callback URL
3. Set the `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` environment variables
4. Install Elixir dependencies with `mix deps.get`
5. Install NodeJS dependencies with `npm install`
7. Start the application with `mix phoenix.server`

Now you can visit `http://localhost:4000` from your browser and click "Sign in
with Google".

After authorizing the application, you should see the welcome message above.

## Understanding the Code

The majority of the work is done in the Google OAuth model
(`web/oauth/google.ex`) and the Auth Controller
(`web/controllers/auth_controller.ex`).

### Google OAuth Model (`web/oauth/google.ex`)

The Google OAuth model wraps [OAuth2](https://github.com/scrogson/oauth2)
and configures the client crendentials, redirect URI, and OAuth2 token and
authorization URLs.

```ex
defmodule Google do
  use OAuth2.Strategy

  # Public API
  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      redirect_uri: System.get_env("GOOGLE_REDIRECT_URI"),
      site: "https://accounts.google.com",
      authorize_url: "/o/oauth2/auth",
      token_url: "/o/oauth2/token"
    ])
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks
  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
```

### Auth Controller (`web/controllers/auth_controller.ex`):

The Auth Controller handles redirecting the user to the authorize URL,
exchanging an authorization code for an access token, and making a request
to Google's API to retrieve a profile picture.

```ex
defmodule GoogleOAuth2Example.AuthController do
  use GoogleOAuth2Example.Web, :controller

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  Google's OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
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
    redirect conn, external: Google.authorize_url!(
      scope: "https://www.googleapis.com/auth/userinfo.email"
    )
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
```
