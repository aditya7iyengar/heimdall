defmodule Asguard.EncryptionTest do
  use ExUnit.Case

  @module Asguard.Encryption

  describe "encrypt/4" do
    test "adds plaintext as encrypted when algo is plaintext" do
      raw = "raw text"
      algo = :plaintext

      encrypted = @module.encrypt(raw, :key, algo)

      assert encrypted == raw
    end

    test "adds encrypted text when alfo is aes_gcm" do
      raw = "raw text"
      algo = :aes_gcm
      key = "secretkey"

      encrypted = @module.encrypt(raw, key, algo)

      refute encrypted == raw
      assert is_binary(encrypted)
    end
  end

  describe "decrypt/4" do
    test "returns encrypted as plaintext when algo is plaintext" do
      text = "plaintext"
      algo = :plaintext

      decrypted = @module.decrypt(text, :key, algo)

      assert decrypted == text
    end

    test "returns encrypted which equals raw when algo is aes_gcm" do
      raw = "raw text"
      algo = :aes_gcm
      key = "secretkey"

      encrypted = @module.encrypt(raw, key, algo)

      decrypted = @module.decrypt(encrypted, key, algo)

      assert decrypted == raw
    end
  end
end
