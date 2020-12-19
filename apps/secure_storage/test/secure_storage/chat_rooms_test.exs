defmodule SecureStorage.ChatRoomsTest do
  use SecureStorage.DataCase

  alias SecureStorage.Repo
  alias SecureStorage.Schema.ChatRoom

  @module SecureStorage.ChatRooms

  describe "insert_new_room/1" do
    test "successfully inserts when params are valid" do
      title = "Some title"

      valid_params = %{
        "title" => title
      }

      {:ok, encrypted_room} = @module.insert_new_room(valid_params)

      assert encrypted_room.title == title
    end

    test "returns invalid changeset when invalid params" do
      invalid_params = %{}

      {:error, changeset} = @module.insert_new_room(invalid_params)

      refute changeset.valid?
    end
  end

  describe "search_rooms/1" do
    setup do
      %ChatRoom{title: "this is not bad"}
      |> ChatRoom.changeset(%{})
      |> Repo.insert!()

      %ChatRoom{title: "this ain't good"}
      |> ChatRoom.changeset(%{})
      |> Repo.insert!()

      :ok
    end

    test "returns one room if only one rooms matches the term" do
      term = "not"
      rooms = @module.search_rooms(term)

      assert Enum.count(rooms) == 1
    end

    test "returns multiple rooms if many match the term" do
      term = "this"
      rooms = @module.search_rooms(term)

      assert Enum.count(rooms) == 2
    end

    test "returns no rooms if none match the term" do
      term = "bad-term"
      rooms = @module.search_rooms(term)

      assert Enum.count(rooms) == 0
    end
  end

  describe "get_room/1" do
    setup do
      room =
        %ChatRoom{title: "title"}
        |> ChatRoom.changeset(%{})
        |> Repo.insert!()

      {:ok, room: room}
    end

    test "returns room with the given id", %{room: room} do
      returned_room = @module.get_room(room.id)

      assert returned_room == room
    end

    test "returns nil if no room with the id exists" do
      returned_room = @module.get_room(Ecto.UUID.generate())

      assert is_nil(returned_room)
    end
  end

  describe "delete_room/1" do
    setup do
      room =
        %ChatRoom{title: "title"}
        |> ChatRoom.changeset(%{})
        |> Repo.insert!()

      {:ok, room: room}
    end

    test "deletes room", %{room: room} do
      assert @module.get_room(room.id)

      {:ok, _returned_room} = @module.delete_room(room)

      refute @module.get_room(room.id)
    end
  end

  describe "list_rooms/1" do
    setup do
      %ChatRoom{title: "desc 1"}
      |> ChatRoom.changeset(%{})
      |> Repo.insert!()

      %ChatRoom{title: "desc 2"}
      |> ChatRoom.changeset(%{})
      |> Repo.insert!()

      :ok
    end

    test "lists all the rooms" do
      rooms = @module.list_rooms

      assert Enum.count(rooms) == 2
    end
  end
end
