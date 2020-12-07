defmodule SecureStorage.Encryption.PlainTest do
  use ExUnit.Case

  @module SecureStorage.Encryption.Plain

  describe "behaviour" do
    test "it behaves like SecureStorage.Encryption" do
      behaviour_modules =
        :attributes
        |> @module.__info__()
        |> Keyword.get(:behaviour)

      assert Enum.member?(behaviour_modules, SecureStorage.Encryption)
    end
  end

  describe "encrypt/2" do
    test "returns raw text itself" do
      assert @module.encrypt("raw", :key) == "raw"
    end
  end

  describe "decrypt/2" do
    test "returns the encrypted text itself" do
      assert @module.decrypt("encrypted", :key) == "encrypted"
    end
  end
end
