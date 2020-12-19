defmodule SecureStorage.ChatRoomsContext do
  @moduledoc """
  Context behaviour to communicate with Chat Rooms
  """

  alias SecureStorage.Schema.ChatRoom

  @callback insert_new_room(map()) ::
              {:ok, ChatRoom.t()} | {:error, Ecto.Changeset.t()}

  @callback get_room(String.t()) :: ChatRoom.t() | nil

  @callback list_rooms() :: list(ChatRoom.t())

  @callback search_rooms(String.t()) :: list(ChatRoom.t())

  @callback expired_rooms() :: list(ChatRoom.t())

  @callback delete_room(ChatRoom.t()) ::
              {:ok, ChatRoom.t()} | {:error, Ecto.Changeset.t()}

  @callback add_participant(ChatRoom.t(), map()) ::
              {:ok, ChatRoom.t()} | {:error, Ecto.Changeset.t()}

  @callback drop_participant(ChatRoom.t(), String.t()) ::
              {:ok, ChatRoom.t()} | {:error, Ecto.Changeset.t()}
end
