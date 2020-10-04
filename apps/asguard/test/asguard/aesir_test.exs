defmodule Asguard.AesirTest do
  use ExUnit.Case

  @module Asguard.Aesir

  describe "from_params/3" do
    test "returns an Aesir struct with given params" do
      aesir =
        @module.from_params(%{
          encrypted: "encrypted",
          encryption_algo: :plaintext,
          description: "description"
        })

      assert aesir.__struct__ == @module
    end
  end

  describe "add_attempt/1" do
    test "updates current_attempts count for an aesir" do
      aesir =
        @module.from_params(%{
          encrypted: "encrypted",
          encryption_algo: :plaintext,
          description: "description"
        })

      assert aesir.current_attempts == 0

      assert @module.add_attempt(aesir).current_attempts == 1
    end
  end
end
