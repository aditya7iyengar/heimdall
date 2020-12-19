defmodule SecureStorage.EncryptedMessagesContext do
  @moduledoc """
  Context behaviour to communicate with Encrypted Messages
  """

  alias SecureStorage.Schema.EncryptedMessage

  @callback insert_new_message(map()) ::
              {:ok, EncryptedMessage.t()} | {:error, Ecto.Changeset.t()}

  @callback insert_encrypted_message(String.t(), String.t(), map()) ::
              {:ok, EncryptedMessage.t()} | {:error, Ecto.Changeset.t()}

  @callback encrypt_message(EncryptedMessage.t(), String.t(), String.t(), map()) ::
              {:ok, EncryptedMessage.t()} | {:error, Ecto.Changeset.t()}

  @callback search_messages(String.t()) :: list(EncryptedMessage.t())

  @callback get_message(String.t()) :: EncryptedMessage.t() | nil

  @callback delete_message(EncryptedMessage.t()) ::
              {:ok, EncryptedMessage.t()} | {:error, Ecto.Changeset.t()}

  @callback list_messages() :: list(EncryptedMessage.t())

  @callback decrypt_message(EncryptedMessage.t(), String.t()) ::
              String.t() | {:error, atom()}
end
