defmodule AsguardTest do
  use ExUnit.Case
  doctest Asguard

  @module Asguard

  describe "insert/4" do
    setup do
      @module.start_link([])
      :ok
    end

    test "inserts when valid arguments" do
      {status, return_value} = @module.insert("raw_string", :key, "Description", :plaintext)

      assert status == :ok
      assert is_binary(return_value)

      # Validate return_value is a UUID string
      {parse_status, _parsed_uuid} = UUID.info(return_value)
      assert parse_status == :ok

      @module.delete(return_value)
    end
  end

  describe "get_encrypted/1" do
    setup do
      @module.start_link([])

      txt = "encrypted"

      inserted_aesir = %@module.Aesir{
        description: "Description",
        encrypted: txt,
        encryption_algo: :plaintext,
        uuid: "cdfdaf44-ee35-11e3-846b-14109ff1a304",
        max_attempts: :infinite,
        iat: DateTime.utc_now(),
        exp: DateTime.utc_now()
      }

      uuid = GenServer.call(@module, {:insert, inserted_aesir})

      on_exit(fn -> @module.delete(uuid) end)

      {:ok, uuid: uuid, txt: txt}
    end

    test "gets encrypted aesir when uuid is present", %{uuid: uuid} do
      {status, aesir} = @module.get_encrypted(uuid)

      assert status == :ok
      assert aesir.__struct__ == @module.Aesir
    end
  end

  describe "get/2" do
    setup do
      @module.start_link([])

      txt = "encrypted"

      inserted_aesir = %@module.Aesir{
        description: "Description",
        encrypted: txt,
        encryption_algo: :plaintext,
        uuid: "cdfdaf44-ee35-11e3-846b-14109ff1a304",
        max_attempts: :infinite,
        iat: DateTime.utc_now(),
        exp: DateTime.utc_now()
      }

      uuid = GenServer.call(@module, {:insert, inserted_aesir})

      on_exit(fn -> @module.delete(uuid) end)

      {:ok, uuid: uuid, txt: txt}
    end

    test "gets decrypted aesir when uuid is present", %{uuid: uuid, txt: txt} do
      {status, result, aesir} = @module.get(uuid, :key)

      assert status == :ok
      assert result == txt
      assert aesir.__struct__ == @module.Aesir
    end
  end

  describe "search/1" do
    setup do
      @module.start_link([])

      txt = "encrypted"

      inserted_aesir = %@module.Aesir{
        description: "Description",
        encrypted: txt,
        encryption_algo: :plaintext,
        uuid: "cdfdaf44-ee35-11e3-846b-14109ff1a304",
        max_attempts: :infinite,
        iat: DateTime.utc_now(),
        exp: DateTime.utc_now()
      }

      uuid = GenServer.call(@module, {:insert, inserted_aesir})

      on_exit(fn -> @module.delete(uuid) end)

      {:ok, uuid: uuid, txt: txt}
    end

    test "gets encrypted aesir when description matches" do
      aesirs = @module.search("Desc")

      assert Enum.count(aesirs) == 1
    end

    test "gets an empty list when description doesn't matche" do
      aesirs = @module.search("bla")

      assert Enum.count(aesirs) == 0
    end
  end

  describe "delete/1" do
    setup do
      @module.start_link([])

      txt = "encrypted"

      inserted_aesir = %@module.Aesir{
        description: "Description",
        encrypted: txt,
        encryption_algo: :plaintext,
        uuid: "cdfdaf44-ee35-11e3-846b-14109ff1a304",
        max_attempts: :infinite,
        iat: DateTime.utc_now(),
        exp: DateTime.utc_now()
      }

      uuid = GenServer.call(@module, {:insert, inserted_aesir})

      on_exit(fn -> @module.delete(uuid) end)

      {:ok, uuid: uuid, txt: txt}
    end

    test "deletes encrypted aesir when uuid is present", %{uuid: uuid} do
      aesirs_before = @module.search("Desc")

      {status, aesir} = @module.delete(uuid)

      aesirs_after = @module.search("Desc")

      assert Enum.count(aesirs_before) == 1
      assert Enum.count(aesirs_after) == 0

      assert status == :ok
      assert aesir.__struct__ == @module.Aesir
    end
  end
end
