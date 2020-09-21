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

  defp generate_uuid() do
    # TODO: Replace with generated UUID
    "cdfdaf44-ee35-11e3-846b-14109ff1a304"
  end
end
