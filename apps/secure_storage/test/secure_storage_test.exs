defmodule SecureStorageTest do
  use ExUnit.Case

  import Mox

  alias SecureStorage.{ChatRoomsMock, EncryptedMessagesMock}

  @module SecureStorage

  describe "insert_new_message/1" do
    setup do
      expect(EncryptedMessagesMock, :insert_new_message, fn _ ->
        {:ok, nil}
      end)

      :ok
    end

    test "calls mock function" do
      assert @module.insert_new_message(nil) == {:ok, nil}
    end
  end

  describe "insert_encrypted_message/3" do
    setup do
      expect(EncryptedMessagesMock, :insert_encrypted_message, fn _, _, _ ->
        {:ok, nil}
      end)

      :ok
    end

    test "calls mock function" do
      assert @module.insert_encrypted_message(nil, nil, nil) == {:ok, nil}
    end
  end

  describe "encrypt_message/4" do
    setup do
      expect(EncryptedMessagesMock, :encrypt_message, fn _, _, _, _ ->
        {:ok, nil}
      end)

      :ok
    end

    test "calls mock function" do
      assert @module.encrypt_message(nil, nil, nil, nil) == {:ok, nil}
    end
  end

  describe "search_messages/1" do
    setup do
      expect(EncryptedMessagesMock, :search_messages, fn _ -> nil end)

      :ok
    end

    test "calls mock function" do
      assert @module.search_messages(nil) == nil
    end
  end

  describe "get_message/1" do
    setup do
      expect(EncryptedMessagesMock, :get_message, fn _ -> {:ok, nil} end)

      :ok
    end

    test "calls mock function" do
      assert @module.get_message(nil) == {:ok, nil}
    end
  end

  describe "delete_message/1" do
    setup do
      expect(EncryptedMessagesMock, :delete_message, fn _ -> {:ok, nil} end)

      :ok
    end

    test "calls mock function" do
      assert @module.delete_message(nil) == {:ok, nil}
    end
  end

  describe "list_messages/0" do
    setup do
      expect(EncryptedMessagesMock, :list_messages, fn -> [] end)

      :ok
    end

    test "calls mock function" do
      assert @module.list_messages() == []
    end
  end

  describe "decrypt_message/2" do
    setup do
      expect(EncryptedMessagesMock, :decrypt_message, fn _, _ ->
        {:ok, nil}
      end)

      :ok
    end

    test "calls mock function" do
      assert @module.decrypt_message(nil, nil) == {:ok, nil}
    end
  end

  describe "insert_new_room/1" do
    setup do
      expect(ChatRoomsMock, :insert_new_room, fn _ ->
        {:ok, nil}
      end)

      :ok
    end

    test "calls mock function" do
      assert @module.insert_new_room(nil) == {:ok, nil}
    end
  end

  describe "search_rooms/1" do
    setup do
      expect(ChatRoomsMock, :search_rooms, fn _ -> nil end)

      :ok
    end

    test "calls mock function" do
      assert @module.search_rooms(nil) == nil
    end
  end

  describe "get_room/1" do
    setup do
      expect(ChatRoomsMock, :get_room, fn _ -> {:ok, nil} end)

      :ok
    end

    test "calls mock function" do
      assert @module.get_room(nil) == {:ok, nil}
    end
  end

  describe "delete_room/1" do
    setup do
      expect(ChatRoomsMock, :delete_room, fn _ -> {:ok, nil} end)

      :ok
    end

    test "calls mock function" do
      assert @module.delete_room(nil) == {:ok, nil}
    end
  end

  describe "list_rooms/0" do
    setup do
      expect(ChatRoomsMock, :list_rooms, fn -> [] end)

      :ok
    end

    test "calls mock function" do
      assert @module.list_rooms() == []
    end
  end
end
