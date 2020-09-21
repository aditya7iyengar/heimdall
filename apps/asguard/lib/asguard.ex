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
    aesir =
      raw
      |> Encryption.encrypt(key, description, encryption_algo)
      |> Aesir.from_params()

    GenServer.call(__MODULE__, {:insert, aesir})
  end

  def get(uuid) do
    GenServer.call(__MODULE__, {:get, uuid})
  end

  # Server callbacks

  @impl true
  def init(aesirs), do: {:ok, aesirs}

  @impl true
  def handle_call({:insert, aesir}, _from, aesirs) do
    {:reply, {:ok, aesir.uuid}, [aesir | aesirs]}
  end

  @impl true
  def handle_call({:get, uuid}, _from, aesirs) do
    case Enum.find(aesirs, &(&1.uuid == uuid)) do
      nil -> {:reply, {:error, :not_found}, aesirs}
      aesir -> {:reply, {:ok, aesir}, aesirs}
    end
  end
end
