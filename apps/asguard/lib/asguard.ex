defmodule Asguard do
  @moduledoc """
  This module is responsible for managing secure information.
  The information is never stored unencrypted.
  """
  use GenServer

  alias __MODULE__.{Aesir, Encryption}

  # Client API

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def insert(raw, key, description, encryption_algo) do
    encrypted = Encryption.encrypt(raw, key, encryption_algo)

    aesir =
      Aesir.from_params(%{
        encrypted: encrypted,
        encryption_algo: encryption_algo,
        description: description
      })

    case GenServer.call(__MODULE__, {:insert, aesir}) do
      nil -> {:error, :could_not_insert}
      uuid -> {:ok, uuid}
    end
  end

  def get_encrypted(uuid) do
    case GenServer.call(__MODULE__, {:get, uuid}) do
      nil ->
        {:error, :not_found}

      aesir ->
        {:ok, aesir}
    end
  end

  def get(uuid, key) do
    case GenServer.call(__MODULE__, {:get, uuid}) do
      nil ->
        {:error, :not_found}

      aesir ->
        decrypted =
          Encryption.decrypt(aesir.encrypted, key, aesir.encryption_algo)
        {:ok, decrypted, aesir}
    end
  end

  # TODO: Write tests for search/1
  def search(description_text) do
    GenServer.call(__MODULE__, {:search, description_text})
  end

  # Server callbacks

  @impl true
  def init(aesirs), do: {:ok, aesirs}

  @impl true
  def handle_call({:insert, aesir}, _from, aesirs) do
    {:reply, aesir.uuid, [aesir | aesirs]}
  end

  @impl true
  def handle_call({:get, uuid}, _from, aesirs) do
    {:reply, Enum.find(aesirs, &(&1.uuid == uuid)), aesirs}
  end

  @impl true
  def handle_call({:search, description_text}, _from, aesirs) do
    {:reply, Enum.filter(aesirs, &(&1.description =~ description_text)), aesirs}
  end
end
