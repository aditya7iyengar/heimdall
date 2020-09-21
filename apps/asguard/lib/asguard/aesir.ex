defmodule Asguard.Aesir do
  @moduledoc false

  @enforce_keys ~w(
    description
    encrypted
    encryption_algo
    uuid
  )a

  @optional_keys ~w(encryption_meta)a

  defstruct @enforce_keys ++ @optional_keys

  def from_params(params) do
    params = Map.put(params, :uuid, generate_uuid())

    struct!(__MODULE__, params)
  end

  defp generate_uuid do
    UUID.uuid1()
  end
end
