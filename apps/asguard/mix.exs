defmodule Asguard.MixProject do
  use Mix.Project

  @version "0.0.0"
  @elixir "~> 1.10.4"

  def project do
    [
      app: :asguard,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: @elixir,
      lockfile: "../../mix.lock",
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:elixir_uuid, "~> 1.2.1"},
      {:excoveralls, "~> 0.13.2", only: :test},
    ]
  end
end
