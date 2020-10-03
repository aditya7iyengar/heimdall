defmodule HeimdallQL.ResolverTest do
  use ExUnit.Case

  @module HeimdallQL.Resolver

  describe "list_aesirs/3" do
    setup do
      Asguard.start_link([])

      {:ok, uuid} = Asguard.insert("raw", :key, "Description", :plaintext)

      {:ok, aesir} = Asguard.get_encrypted(uuid)

      on_exit(fn ->
        Asguard.delete(uuid)
      end)

      {:ok, aesir: aesir}
    end

    test "lists aesirs", %{aesir: aesir} do
      {status, list} = @module.list_aesirs(nil, nil, nil)

      assert status == :ok
      assert list == [aesir]
    end
  end

  describe "get_aesir/3" do
    setup do
      Asguard.start_link([])

      {:ok, uuid} = Asguard.insert("raw", :key, "Description", :plaintext)

      {:ok, aesir} = Asguard.get_encrypted(uuid)

      on_exit(fn ->
        Asguard.delete(uuid)
      end)

      {:ok, aesir: aesir}
    end

    test "gets aesir", %{aesir: aesir} do
      {status, fetched} = @module.get_aesir(nil, %{uuid: aesir.uuid}, nil)

      assert status == :ok
      assert fetched == aesir
    end
  end

  describe "create_aesirs/3" do
    test "creates aesir" do
      params = %{
        raw: "raw",
        key: :key,
        description: "Description",
        encryption_algo: "plaintext"
      }

      {status, created} = @module.create_aesir(nil, params, nil)

      on_exit(fn ->
        Asguard.delete(created.uuid)
      end)

      assert status == :ok
      assert created.encrypted == params.raw
      assert created.description == params.description
      assert to_string(created.encryption_algo) == params.encryption_algo
    end
  end
end
