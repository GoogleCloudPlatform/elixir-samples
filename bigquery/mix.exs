defmodule GoogleApi.BigQuery.Samples.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bigquery_samples,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :goth]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:google_api_big_query , "~> 0.0.1"},
      {:goth, "~> 0.7.0"}
    ]
  end
end
