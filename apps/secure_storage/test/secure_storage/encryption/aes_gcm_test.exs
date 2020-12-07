defmodule SecureStorage.Encryption.AesGcmTest do
  use ExUnit.Case

  @module SecureStorage.Encryption.AesGcm

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
    test "adds encrypted text" do
      raw = "raw text"
      key = "secretkey"

      encrypted = @module.encrypt(raw, key)

      refute encrypted == raw
      assert is_binary(encrypted)
    end
  end

  describe "decrypt/2" do
    test "returns encrypted which equals raw" do
      raw = "raw text"
      key = "secretkey"

      encrypted = @module.encrypt(raw, key)

      decrypted = @module.decrypt(encrypted, key)

      assert decrypted == raw
    end

    test "returns :error when bad key is provided" do
      raw = "raw text"
      key = "secretkey"

      encrypted = @module.encrypt(raw, key)

      decrypted = @module.decrypt(encrypted, "bad")

      assert decrypted == :error
    end
  end
end
