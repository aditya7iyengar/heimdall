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

  def insert(raw, key, encryption_algo, params, ttl \\ 5) do
    encrypted = Encryption.encrypt(raw, key, encryption_algo)

    params =
      params
      |> Map.put(:encrypted, encrypted)
      |> Map.put(:encryption_algo, encryption_algo)

    aesir = Aesir.from_params(params, ttl)

    uuid = GenServer.call(__MODULE__, {:insert, aesir})

    {:ok, uuid}
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
    with aesir when not is_nil(aesir) <- GenServer.call(__MODULE__, {:get, uuid}),
         true <- decryption_attempts_remaining?(aesir),
         d when d != :error <- Encryption.decrypt(aesir.encrypted, key, aesir.encryption_algo) do
      maybe_add_decryption(uuid)
      {:ok, d, aesir}
    else
      nil ->
        {:error, :not_found}

      false ->
        {:error, :no_attempts_remaining}

      :error ->
        maybe_add_attempt(uuid)
        {:error, :decryption_error}
    end
  end

  defp decryption_attempts_remaining?(aesir) do
    %Aesir{
      max_attempts: max_attempts,
      current_attempts: current_attempts,
      max_decryptions: max_decryptions,
      current_decryptions: current_decryptions
    } = aesir

    (max_decryptions == :infinite || max_decryptions > current_decryptions) &&
      (max_attempts == :infinite || max_attempts > current_attempts)
  end

  defp maybe_add_attempt(uuid) do
    aesir =
      __MODULE__
      |> GenServer.call({:get, uuid})
      |> Aesir.add_attempt()

    # TODO: Replace with update function
    delete(uuid)
    GenServer.call(__MODULE__, {:insert, aesir})
  end

  defp maybe_add_decryption(uuid) do
    aesir =
      __MODULE__
      |> GenServer.call({:get, uuid})
      |> Aesir.add_decryption()

    # TODO: Replace with update function
    delete(uuid)
    GenServer.call(__MODULE__, {:insert, aesir})
  end

  def delete(uuid) do
    case GenServer.call(__MODULE__, {:delete, uuid}) do
      nil ->
        {:error, :not_found}

      aesir ->
        {:ok, aesir}
    end
  end

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

  def handle_call({:delete, uuid}, _from, aesirs) do
    aesir = Enum.find(aesirs, &(&1.uuid == uuid))
    {:reply, aesir, aesirs -- [aesir]}
  end

  @impl true
  def handle_call({:search, description_text}, _from, aesirs) do
    {:reply, Enum.filter(aesirs, &(&1.description =~ description_text)), aesirs}
  end
end
