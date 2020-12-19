defmodule SecureStorage.Encryption.Plain do
  @moduledoc """
  Module corresponding to Plain encryption
  """

  @behaviour SecureStorage.Encryption

  @impl true
  def encrypt(raw, _key), do: raw

  @impl true
  def decrypt(encrypted, _key), do: encrypted
end
