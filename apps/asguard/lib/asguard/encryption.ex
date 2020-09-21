defmodule Asguard.Encryption do
  @moduledoc false

  def encrypt(raw, key, description, encryption_algo \\ :aes_ecb)

  def encrypt(raw, key, description, :aes_ecb) do
    %{
      description: description,
      # TODO: Replace with encrypted data
      encrypted: raw,
      encryption_algo: :aes_ecb
    }
  end

  def encrypt(raw, _key, description, :plaintext) do
    %{
      description: description,
      # TODO: Replace with encrypted data
      encrypted: raw,
      encryption_algo: :plaintext
    }
  end
end
