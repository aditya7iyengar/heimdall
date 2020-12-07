defmodule SecureStorage do
  @moduledoc """
  Documentation for `SecureStorage`.

  Database and encryption context for Heimdall
  """

  alias SecureStorage.EncryptedMessages

  defdelegate insert_new_message(params), to: EncryptedMessages

  defdelegate insert_encrypted_message(raw, key, params), to: EncryptedMessages

  defdelegate encrypt_message(message, raw, key, params), to: EncryptedMessages
end
