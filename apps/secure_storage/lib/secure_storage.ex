defmodule SecureStorage do
  @moduledoc """
  Documentation for `SecureStorage`.

  Database and encryption context for Heimdall
  """

  alias SecureStorage.EncryptedMessages

  @messages_context Keyword.get(
                      Application.compile_env(:secure_storage, __MODULE__, []),
                      :messages_context,
                      EncryptedMessages
                    )

  @rooms_context Keyword.get(
                   Application.compile_env(:secure_storage, __MODULE__, []),
                   :rooms_context,
                   EncryptedMessages
                 )

  ## Messages Client

  defdelegate insert_new_message(params), to: @messages_context

  defdelegate insert_encrypted_message(raw, key, params), to: @messages_context

  defdelegate encrypt_message(message, raw, key, params), to: @messages_context

  defdelegate search_messages(term), to: @messages_context

  defdelegate get_message(id), to: @messages_context

  defdelegate delete_message(id), to: @messages_context

  defdelegate list_messages, to: @messages_context

  defdelegate decrypt_message(message, key), to: @messages_context

  # Rooms Client

  defdelegate insert_new_room(params), to: @rooms_context

  defdelegate get_room(id), to: @rooms_context

  defdelegate list_rooms, to: @rooms_context

  defdelegate search_rooms(term), to: @rooms_context

  defdelegate delete_room(room), to: @rooms_context

  defdelegate expired_rooms, to: @rooms_context

  defdelegate add_participant(room, params), to: @rooms_context

  defdelegate drop_participant(room, params), to: @rooms_context
end
