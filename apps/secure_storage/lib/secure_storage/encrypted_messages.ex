defmodule SecureStorage.EncryptedMessages do
  @moduledoc """
  Simpler interface to manage encrypted messages
  """
  import Ecto.Changeset

  alias SecureStorage.Encryption.{AesGcm, Plain}
  alias SecureStorage.Repo
  alias SecureStorage.Schema.EncryptedMessage

  # 5 mins (300 seconds) default TTL
  @default_ttl 5

  def insert_new_message(params) do
    params
    |> change_message()
    |> Repo.insert()
  end

  def insert_encrypted_message(raw, key, params) do
    with changeset = %{valid?: true} <- change_message(params),
         message = apply_changes(changeset) do
      encrypt_message(message, raw, key, params)
    else
      changeset = %{valid?: false} -> {:error, changeset}
    end
  end

  def encrypt_message(message, raw, key, params) do
    with {:ok, txt} <- encrypt(message, raw, key),
         changeset = %{valid?: false} <- add_encrypted(message, txt, params) do
      Repo.insert(changeset)
    else
      changeset = %{valid?: false} ->
        {:error, changeset}

      {:error, :error_in_encryption} ->
        changeset =
          params
          |> change_message()
          |> add_error(:encryption_algo, "Something went wrong in Encryption")

        {:error, changeset}
    end
  end

  defp add_encrypted(message, txt, params) do
    ttl = Map.get(params, :ttl, @default_ttl) * 60
    enc_at = DateTime.utc_now()
    exp_at = DateTime.add(enc_at, ttl, :second)

    params =
      params
      |> Map.drop([:ttl])
      |> Map.put(:exp_at, exp_at)
      |> Map.put(:state, :new)
      |> Map.put_new(:txt, txt)

    EncryptedMessage.changeset(message, params)
  end

  defp change_message(params) do
    params
    |> Map.put(:state, :new)
    |> EncryptedMessage.changeset()
  end

  defp encrypt(%EncryptedMessage{encryption_algo: :plain}, raw, key) do
    Plain.encrypt(raw, key)
  end

  defp encrypt(%EncryptedMessage{encryption_algo: :aes_gcm}, raw, key) do
    AesGcm.encrypt(raw, key)
  end
end
