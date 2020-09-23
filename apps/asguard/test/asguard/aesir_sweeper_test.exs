defmodule Asguard.AesirSweeperTest do
  use ExUnit.Case

  @module Asguard.AesirSweeper

  describe "run/0" do
    setup do
      Asguard.start_link([])

      txt = "encrypted"

      new_aesir = %Asguard.Aesir{
        description: "Description",
        encrypted: txt,
        encryption_algo: :plaintext,
        uuid: "cdfdaf44-ee35-11e3-846b-14109ff1a304",
        iat: DateTime.utc_now(),
        exp: DateTime.add(DateTime.utc_now(), 10_000, :second)
      }

      old_aesir = %Asguard.Aesir{
        description: "Description",
        encrypted: txt,
        encryption_algo: :plaintext,
        uuid: "cdfdaf44-ee35-11e3-846b-14109ff1a305",
        iat: DateTime.utc_now(),
        exp: DateTime.utc_now()
      }

      new_uuid = GenServer.call(Asguard, {:insert, new_aesir})
      old_uuid = GenServer.call(Asguard, {:insert, old_aesir})

      on_exit(fn ->
        Asguard.delete(new_uuid)
        Asguard.delete(old_uuid)
      end)

      {:ok, new_uuid: new_uuid, old_uuid: old_uuid}
    end

    test "deletes only expired aesirs", %{new_uuid: new, old_uuid: old} do
      {:ok, _} = Asguard.get_encrypted(new)
      {:ok, _} = Asguard.get_encrypted(old)

      @module.run

      {:ok, _} = Asguard.get_encrypted(new)
      {:error, reason} = Asguard.get_encrypted(old)

      assert reason == :not_found
    end
  end
end
