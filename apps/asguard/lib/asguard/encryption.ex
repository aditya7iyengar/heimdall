defmodule Asguard.Encryption do
  @moduledoc false

  def encrypt(raw, _key, :plaintext), do: raw

  def encrypt(raw, key, :aes_gcm) do
    secret_key = :crypto.hash(:md5, key)
    initialization_vector = :crypto.strong_rand_bytes(16)

    {ciphertext, ciphertag} =
      :crypto.block_encrypt(
        :aes_gcm,
        secret_key,
        initialization_vector,
        {"AES256GCM", raw, 16}
      )

    :base64.encode(initialization_vector <> ciphertag <> ciphertext)
  end

  def decrypt(encrypted, _key, :plaintext), do: encrypted

  def decrypt(encrypted, key, :aes_gcm) do
    secret_key = :crypto.hash(:md5, key)

    <<initialization_vector::binary-16, ciphertag::binary-16, ciphertext::binary>> =
      :base64.decode(encrypted)

    :crypto.block_decrypt(
      :aes_gcm,
      secret_key,
      initialization_vector,
      {"AES256GCM", ciphertext, ciphertag}
    )
  end
end
