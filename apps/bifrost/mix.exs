defmodule Bifrost.MixProject do
  use Mix.Project

  @version "0.0.2"
  @elixir "1.10.4"

  def project do
    [
      aliases: aliases(),
      app: :bifrost,
      build_path: "../../_build",
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
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

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bifrost.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe_phoenix, "~> 2.0.0"},
      {:absinthe_plug, "~> 1.5.0"},
      {:asguard, in_umbrella: true},
      {:excoveralls, "~> 0.13.2", only: :test},
      {:floki, ">= 0.27.0", only: :test},
      {:gettext, "~> 0.11"},
      {:heimdall_ql, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.5.5"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.14.6"},
      {:plug_cowboy, "~> 2.0"},
      {:quantum, "~> 3.2.0"},
      {:sobelow, "~> 0.8", only: :dev},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"]
    ]
  end
end
