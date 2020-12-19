defmodule SecureStorage.Sweeper do
  @moduledoc """
  Deletes stale/expired messages
  """

  @doc """
  Deletes stale or expired messages
  """
  def run do
    SecureStorage.EncryptedMessages.stale_or_expired_messages()
    |> Enum.each(&SecureStorage.Repo.delete/1)
  end
end
