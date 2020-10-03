defmodule HeimdallQL.Resolver do
  @moduledoc false

  def list_aesirs(_, _, _) do
    Asguard.search("")
  end
end
