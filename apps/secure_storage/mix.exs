defmodule SecureStorage.MixProject do
  use Mix.Project

  @version "0.0.2"
  @elixir "1.10.4"

  def project do
    [
      app: :secure_storage,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: @elixir,
      elixirc_paths: elixirc_paths(Mix.env()),
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
      mod: {SecureStorage.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.5.5"},
      {:ecto_sql, "~> 3.5.3"},
      {:elixir_uuid, "~> 1.2.1"},
      {:excoveralls, "~> 0.13.2", only: :test},
      {:mox, "~> 1.0.0", only: :test},
      {:postgrex, "~> 0.15.7"}
    ]
  end

  defp elixirc_paths(e) when e in [:test], do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
