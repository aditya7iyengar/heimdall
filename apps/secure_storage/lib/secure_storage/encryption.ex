defmodule SecureStorage.Encryption do
  @moduledoc """
  Behaviour module for encryption behaviour that corresponds to an
  encryption algorithm
  """

  @callback encrypt(raw :: String.t(), key :: String.t()) :: String.t()
  @callback decrypt(encrypted :: String.t(), key :: String.t()) :: String.t()
end
