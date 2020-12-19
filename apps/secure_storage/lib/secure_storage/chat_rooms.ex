defmodule SecureStorage.ChatRooms do
  @moduledoc """
  Simpler interface to manage chat rooms
  """
  import Ecto.Query

  alias SecureStorage.Repo
  alias SecureStorage.Schema.ChatRoom

  @behaviour SecureStorage.ChatRoomsContext

  @impl true
  def insert_new_room(params) do
    params
    |> change_room()
    |> Repo.insert()
  end

  @impl true
  def get_room(id) do
    Repo.get(ChatRoom, id)
  end

  @impl true
  def list_rooms do
    Repo.all(ChatRoom)
  end

  @impl true
  def search_rooms(term) do
    term = "%#{term}%"

    ChatRoom
    |> where([r], ilike(r.title, ^term))
    |> Repo.all()
  end

  @impl true
  def delete_room(room) do
    Repo.delete(room)
  end

  @impl true
  def expired_rooms do
    ChatRoom
    |> where([r], r.exp_at < ^DateTime.utc_now())
    |> Repo.all()
  end

  @impl true
  def add_participant(room, _participant_params) do
    # TODO: Implement this
    {:ok, room}
  end

  @impl true
  def drop_participant(room, _participant_name) do
    # TODO: Implement this
    {:ok, room}
  end

  defp change_room(params) do
    ChatRoom.changeset(params)
  end
end
