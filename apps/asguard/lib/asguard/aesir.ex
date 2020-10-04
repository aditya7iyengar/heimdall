defmodule Asguard.Aesir do
  @moduledoc false

  @enforce_keys ~w(
    description
    encrypted
    encryption_algo
    max_attempts
    current_attempts
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
      |> Map.put_new(:max_attempts, :infinite)
      |> Map.put(:current_attempts, 0)

    struct!(__MODULE__, params)
  end

  def add_attempt(%__MODULE__{current_attempts: current_attempts} = aesir) do
    %__MODULE__{aesir | current_attempts: current_attempts + 1}
  end

  defp generate_uuid do
    UUID.uuid1()
  end
end
