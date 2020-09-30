defmodule Asguard.Aesir do
  @moduledoc false

  @enforce_keys ~w(
    description
    encrypted
    encryption_algo
    uuid
    iat
    exp
  )a

  @optional_keys ~w(encryption_meta)a

  defstruct @enforce_keys ++ @optional_keys

  def from_params(params, ttl \\ 5, iat \\ DateTime.utc_now()) do
    params =
      params
      |> Map.put(:uuid, generate_uuid())
      |> Map.put(:iat, iat)
      |> Map.put(:exp, DateTime.add(iat, ttl * 60, :second))

    struct!(__MODULE__, params)
  end

  defp generate_uuid do
    UUID.uuid1()
  end
end
