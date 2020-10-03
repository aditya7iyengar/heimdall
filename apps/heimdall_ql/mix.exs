defmodule HeimdallQL.MixProject do
  use Mix.Project

  @version "0.0.0"
  @elixir "1.10.4"

  def project do
    [
      app: :heimdall_ql,
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
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:absinthe, "~> 1.5.3"},
      {:asguard, in_umbrella: true},
      {:excoveralls, "~> 0.13.2", only: :test}
    ]
  end

  defp elixirc_paths(e) when e in [:dev, :test], do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
