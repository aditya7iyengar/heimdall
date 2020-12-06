defmodule SecureStorage.Schema do
  @moduledoc """
  Shared schema for DB Access
  """

  @callback changeset(Ecto.Schema.t(), map()) :: Ecto.Changeset.t()

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @behaviour unquote(__MODULE__)

      @primary_key {:id, :binary_id, autogenerate: true}

      @impl true
      def changeset(struct, params) do
        struct
        |> cast(params, __MODULE__.__info__(:fields))
      end

      defoverridable changeset: 2
    end
  end
end
