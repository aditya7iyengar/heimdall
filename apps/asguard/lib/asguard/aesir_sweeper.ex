defmodule Asguard.AesirSweeper do
  @moduledoc """
  Sweeps expired aesirs
  """

  def run do
    ""
    |> Asguard.search()
    |> Enum.filter(&(DateTime.compare(&1.exp, DateTime.utc_now()) == :lt))
    |> Enum.map(& &1.uuid)
    |> Enum.each(&Asguard.delete/1)
  end
end
