defmodule GoogleApi.StackdriverLogging.Samples.MixProject do
  use Mix.Project

  def project do
    [
      app: :stackdriver_logging_samples,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:goth, "~> 1.1"},
      {:google_api_logging, "~> 0.17"}
    ]
  end
end
