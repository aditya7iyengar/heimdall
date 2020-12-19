defmodule SecureStorage.EncryptedMessages do
  @moduledoc """
  Simpler interface to manage encrypted messages
  """
  import Ecto.Changeset
  import Ecto.Query

  alias SecureStorage.Encryption.{AesGcm, Plain}
  alias SecureStorage.Repo
  alias SecureStorage.Schema.EncryptedMessage

  @behaviour SecureStorage.EncryptedMessagesContext

  # 5 mins (300 seconds) default TTL
  @default_ttl 5

  @impl true
  def insert_new_message(params) do
    params
    |> change_message()
    |> Repo.insert()
  end

  @impl true
  def insert_encrypted_message(raw, key, params) do
    with changeset = %{valid?: true} <- change_message(params),
         message = apply_changes(changeset) do
      encrypt_message(message, raw, key, params)
    else
      changeset = %{valid?: false} -> {:error, changeset}
    end
  end

  @impl true
  def encrypt_message(message, raw, key, params) do
    encryption_result = encrypt(message, raw, key)

    with {:encrypt, txt} when txt != :error <- {:encrypt, encryption_result},
         changeset = %{valid?: true} <- add_encrypted(message, txt, params) do
      Repo.insert_or_update(changeset)
    else
      changeset = %{valid?: false} ->
        {:error, changeset}

      {:encrypt, :error} ->
        changeset =
          params
          |> change_message()
          |> add_error(:encryption_algo, "Something went wrong in Encryption")

        {:error, changeset}
    end
  end

  @impl true
  def search_messages(term) do
    term = "%#{term}%"

    EncryptedMessage
    |> where([m], ilike(m.short_description, ^term))
    |> Repo.all()
  end

  @impl true
  def get_message(id) do
    Repo.get(EncryptedMessage, id)
  end

  @impl true
  def delete_message(message) do
    Repo.delete(message)
  end

  @impl true
  def list_messages do
    Repo.all(EncryptedMessage)
  end

  @impl true
  def decrypt_message(message, key, ip \\ "none") do
    message = Repo.get!(EncryptedMessage, message.id)

    attempts_remaining = message.max_attempts > Enum.count(message.attempts)
    reads_remaining = message.max_reads > Enum.count(message.reads)

    with {:attempts, true} <- {:attempts, attempts_remaining},
         {:reads, true} <- {:reads, reads_remaining},
         {:decrypt, decrypted} when is_binary(decrypted) <- {:decrypt, decrypt(message, key)} do
      add_reads!(message, ip)
      {:ok, decrypted}
    else
      {:attempts, false} ->
        {:error, :no_attempts_remaining}

      {:reads, false} ->
        {:error, :no_reads_remaining}

      {:decrypt, :error} ->
        add_attempts!(message, ip)
        {:error, :decryption_error}
    end
  end

  def stale_or_expired_messages do
    stale_or_expired_states = ~w(expired no_attempts_left no_reads_left)a

    EncryptedMessage
    |> where([m], m.state in ^stale_or_expired_states)
    |> Repo.all()
  end

  defp add_encrypted(message, txt, params) do
    ttl = get_ttl(params)
    enc_at = DateTime.utc_now()
    exp_at = DateTime.add(enc_at, ttl, :second)

    params =
      params
      |> Map.drop(["ttl"])
      |> Map.put("enc_at", enc_at)
      |> Map.put("exp_at", exp_at)
      |> Map.put("state", "encrypted")
      |> Map.put_new("txt", txt)

    EncryptedMessage.changeset(message, params)
  end

  defp change_message(params) do
    params
    |> Map.put("state", "new")
    |> EncryptedMessage.changeset()
  end

  defp encrypt(%EncryptedMessage{encryption_algo: :plain}, raw, key) do
    Plain.encrypt(raw, key)
  end

  defp encrypt(%EncryptedMessage{encryption_algo: :aes_gcm}, raw, key) do
    AesGcm.encrypt(raw, key)
  end

  defp decrypt(%EncryptedMessage{encryption_algo: :plain} = msg, key) do
    Plain.decrypt(msg.txt, key)
  end

  defp decrypt(%EncryptedMessage{encryption_algo: :aes_gcm} = msg, key) do
    AesGcm.decrypt(msg.txt, key)
  end

  defp get_ttl(params) do
    case Map.get(params, "ttl", @default_ttl) do
      mins when is_binary(mins) -> String.to_integer(mins) * 60
      mins when is_integer(mins) -> mins * 60
    end
  end

  defp add_attempts!(message, ip) do
    attempt = %{ip: ip, at: DateTime.utc_now(), failure_reason: "decryption"}
    attempts = message.attempts |> Enum.map(&Map.from_struct/1)

    message
    |> EncryptedMessage.changeset(%{"attempts" => [attempt | attempts]})
    |> Repo.update!()
  end

  defp add_reads!(message, ip) do
    read = %{ip: ip, at: DateTime.utc_now()}
    reads = message.reads |> Enum.map(&Map.from_struct/1)

    message
    |> EncryptedMessage.changeset(%{"reads" => [read | reads]})
    |> Repo.update!()
  end
end
