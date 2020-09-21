defmodule Heimdall.MixProject do
  use Mix.Project

  @version "0.0.0"

  def project do
    [
      apps_path: "apps",
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  defp deps do
    []
  end
end
