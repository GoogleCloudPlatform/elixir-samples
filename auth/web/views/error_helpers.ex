defmodule GoogleOAuth2Example.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    if error = form.errors[field] do
      {msg, _} = error
      content_tag :span, msg, class: "help-block"
    end
  end
end
