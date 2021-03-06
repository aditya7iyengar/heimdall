defmodule Heimdall.MixProject do
  use Mix.Project

  @version "0.0.2"

  def project do
    [
      aliases: aliases(),
      apps_path: "apps",
      deps: deps(),
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

  defp deps do
    [
      {:credo, "~> 1.5.1", only: :dev},
      {:excoveralls, "~> 0.13.2", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.reset", "test"]
    ]
  end
end
