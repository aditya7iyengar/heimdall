defmodule EctoTestHelpers do
  @moduledoc """
  Documentation for `EctoTestHelpers`.

  These functions make testing `Ecto.Changeset`s a lot easier
  """

  def validates_required?(changeset, field) when is_atom(field) do
    Enum.member?(changeset.required, field)
  end

  def validates_required?(changeset, fields) when is_list(fields) do
    Enum.all?(fields, &validates_required?(changeset, &1))
  end

  def validates_inclusion?(changeset, field, values) do
    Enum.any?(changeset.validations, fn
      {^field, {:inclusion, enum}} -> Enum.sort(values) == Enum.sort(enum)
      _ -> false
    end)
  end

  def validates_number?(changeset, field, opts) do
    Enum.any?(changeset.validations, fn
      {^field, {:number, ^opts}} -> true
      _ -> false
    end)
  end

  def validates_format?(changeset, field, format) do
    Enum.any?(changeset.validations, fn
      {^field, {:format, ^format}} -> true
      _ -> false
    end)
  end

  def validates_length?(changeset, field, opts) do
    Enum.any?(changeset.validations, fn
      {^field, {:length, ^opts}} -> true
      _ -> false
    end)
  end

  def embeds_one?(mod, field, related) do
    case mod.__schema__(:embed, field) do
      %Ecto.Embedded{cardinality: :one, related: ^related} -> true
      _ -> false
    end
  end

  def embeds_many?(mod, field, related) do
    case mod.__schema__(:embed, field) do
      %Ecto.Embedded{cardinality: :many, related: ^related} -> true
      _ -> false
    end
  end
end
