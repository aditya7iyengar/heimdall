defmodule SecureStorage.Encryption.AesGcm do
  @moduledoc """
  Module corresponding to AES Gcm encryption
  """

  @behaviour SecureStorage.Encryption

  @crypt "AES256GCM"

  @impl true
  def encrypt(raw, key) do
    secret_key = :crypto.hash(:md5, key)
    initialization_vector = :crypto.strong_rand_bytes(16)

    {ciphertext, ciphertag} =
      :crypto.block_encrypt(
        :aes_gcm,
        secret_key,
        initialization_vector,
        {@crypt, raw, 16}
      )

    :base64.encode(initialization_vector <> ciphertag <> ciphertext)
  end

  @impl true
  def decrypt(encrypted, key) do
    secret_key = :crypto.hash(:md5, key)

    <<initialization_vector::binary-16, ciphertag::binary-16, ciphertext::binary>> =
      :base64.decode(encrypted)

    :crypto.block_decrypt(
      :aes_gcm,
      secret_key,
      initialization_vector,
      {@crypt, ciphertext, ciphertag}
    )
  end
end
