defmodule HeimdallQL.Resolver do
  @moduledoc false

  def list_aesirs(_, _, _) do
    {:ok, Asguard.search("")}
  end
end
