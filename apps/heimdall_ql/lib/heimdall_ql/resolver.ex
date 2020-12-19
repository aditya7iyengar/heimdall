defmodule HeimdallQL.Resolver do
  @moduledoc false

  def list_encrypted_messages(_, _, _) do
    {:ok, SecureStorage.list_messages()}
  end

  def get_encrypted_message(_, %{id: id}, _) do
    case SecureStorage.get_message(id) do
      nil -> {:error, "Not found"}
      encrypted_message -> {:ok, encrypted_message}
    end
  end

  def create_encrypted_message(_, params, _) do
    args = parse_create_params_to_args(params)

    apply(SecureStorage, :insert_encrypted_message, args)
  end

  defp parse_create_params_to_args(params) do
    [
      Map.fetch!(params, :raw),
      Map.fetch!(params, :key),
      params_to_string_map(params)
    ]
  end

  defp params_to_string_map(params) do
    params
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> {to_string(k), v} end)
    |> Enum.into(%{})
  end
end
