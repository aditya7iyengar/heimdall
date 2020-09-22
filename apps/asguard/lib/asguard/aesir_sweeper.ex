defmodule Asguard.AesirSweeper do
  @moduledoc """
  Sweeps expired aesirs
  """

  def run do
    ""
    |> Asguard.search()
    |> Enum.map(& &1.uuid)
    |> Enum.filter(&(DateTime.compare(&1.exp, DateTime.utc_now()) == :lt))
    |> Enum.each(&Asguard.delete/1)
  end
end
