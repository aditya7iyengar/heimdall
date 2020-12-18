defmodule SecureStorage do
  @moduledoc """
  Documentation for `SecureStorage`.

  Database and encryption context for Heimdall
  """

  alias SecureStorage.EncryptedMessages

  @context Keyword.get(
             Application.compile_env(:secure_storage, __MODULE__, []),
             :context,
             EncryptedMessages
           )

  defdelegate insert_new_message(params), to: @context

  defdelegate insert_encrypted_message(raw, key, params), to: @context

  defdelegate encrypt_message(message, raw, key, params), to: @context

  defdelegate search_messages(term), to: @context

  defdelegate get_message(id), to: @context

  defdelegate delete_message(id), to: @context

  defdelegate list_messages, to: @context

  defdelegate decrypt_message(message, key), to: @context
end
