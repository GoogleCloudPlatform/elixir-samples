defmodule GoogleOAuth2Example.User do
  @moduledoc """
  The `current_user` is stored in the connection as a map
  with string keys.
  """

  def name(user), do: user["name"]
  def email(user), do: user["email"]
end
