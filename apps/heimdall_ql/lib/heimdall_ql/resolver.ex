defmodule HeimdallQL.Resolver do
  @moduledoc false

  def list_aesirs(_, _, _) do
    {:ok, Asguard.search("")}
  end

  def get_aesir(_, %{uuid: uuid}, _) do
    Asguard.get_encrypted(uuid)
  end

  def create_aesir(_, params, _) do
    args = parse_create_params_to_args(params)

    {:ok, uuid} = apply(Asguard, :insert, args)
    Asguard.get_encrypted(uuid)
  end

  defp parse_create_params_to_args(params) do
    [
      Map.fetch!(params, :raw),
      Map.fetch!(params, :key),
      Map.fetch!(params, :description),
      params |> Map.get(:encryption_algo, "aes_gcm") |> String.to_atom(),
      Map.get(params, :ttl, 5)
    ]
  end
end
