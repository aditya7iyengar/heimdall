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
        iat: DateTime.utc_now(),
        exp: DateTime.utc_now()
      }

      uuid = GenServer.call(@module, {:insert, inserted_aesir})

      {:ok, uuid: uuid, txt: txt}
    end

    test "gets decrypted aesir when uuid is present", %{uuid: uuid, txt: txt} do
      {status, result, aesir} = @module.get(uuid, :key)

      assert status == :ok
      assert result == txt
      assert aesir.__struct__ == @module.Aesir
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
        iat: DateTime.utc_now(),
        exp: DateTime.utc_now()
      }

      uuid = GenServer.call(@module, {:insert, inserted_aesir})

      {:ok, uuid: uuid, txt: txt}
    end

    test "gets encrypted aesir when uuid is present", %{uuid: uuid} do
      {status, aesir} = @module.get_encrypted(uuid)

      assert status == :ok
      assert aesir.__struct__ == @module.Aesir
    end
  end
end
