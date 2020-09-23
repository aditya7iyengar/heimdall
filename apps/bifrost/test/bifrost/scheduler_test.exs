defmodule Bifrost.SchedulerTest do
  use ExUnit.Case

  @module Bifrost.Scheduler

  describe "Quantum behaviour" do
    test "is a Quantum Scheduler" do
      assert @module.module_info()
             |> Keyword.get(:attributes, [])
             |> Keyword.get(:behaviour, [])
             |> Enum.member?(Quantum)
    end
  end
end
