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
      {status, return_value} =
        @module.insert(
          "raw_string",
          :key,
          :plaintext,
          %{description: "Description"}
        )

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
        current_attempts: 0,
        max_decryptions: :infinite,
        current_decryptions: 0,
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

      params = %{
        description: "Description",
        max_attempts: 1,
        max_decryptions: 5
      }

      {:ok, uuid} = @module.insert(txt, "key", :aes_gcm, params)

      on_exit(fn -> @module.delete(uuid) end)

      {:ok, uuid: uuid, txt: txt}
    end

    test "gets decrypted aesir when uuid is present", %{uuid: uuid, txt: txt} do
      {status, result, aesir} = @module.get(uuid, "key")

      assert status == :ok
      assert result == txt
      assert aesir.__struct__ == @module.Aesir
    end

    test "updates attempts and returns error when decryption fails",
         %{uuid: uuid} do
      {:ok, aesir} = @module.get_encrypted(uuid)
      assert aesir.current_attempts == 0

      {status, error} = @module.get(uuid, "bad-key")

      assert status == :error
      assert error == :decryption_error

      {:ok, aesir} = @module.get_encrypted(uuid)
      assert aesir.current_attempts == 1
    end

    test "when max_attempts have been met, returns error", %{uuid: uuid} do
      {:ok, aesir} = @module.get_encrypted(uuid)
      assert aesir.current_attempts == 0

      @module.get(uuid, "bad-key")

      {:ok, aesir} = @module.get_encrypted(uuid)
      assert aesir.current_attempts == aesir.max_attempts

      {status, error} = @module.get(uuid, "key")

      assert status == :error
      assert error == :no_attempts_remaining
    end

    test "updates decryptions and returns error when decryption fails",
         %{uuid: uuid} do
      {:ok, aesir} = @module.get_encrypted(uuid)
      old_decryptions = aesir.current_decryptions

      @module.get(uuid, "key")

      {:ok, aesir} = @module.get_encrypted(uuid)
      new_decryptions = aesir.current_decryptions

      assert new_decryptions == old_decryptions + 1
    end

    test "when max_decryptions have been met, returns error", %{uuid: uuid} do
      {:ok, old_aesir} = @module.get_encrypted(uuid)
      new_aesir = %Asguard.Aesir{old_aesir | current_decryptions: old_aesir.max_decryptions}

      @module.delete(old_aesir.uuid)
      GenServer.call(@module, {:insert, new_aesir})

      on_exit(fn ->
        @module.delete(new_aesir.uuid)
        GenServer.call(@module, {:insert, old_aesir})
      end)

      {status, error} = @module.get(uuid, "key")

      assert status == :error
      assert error == :no_attempts_remaining
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
        current_attempts: 0,
        max_decryptions: :infinite,
        current_decryptions: 0,
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
        current_attempts: 0,
        max_decryptions: :infinite,
        current_decryptions: 0,
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
