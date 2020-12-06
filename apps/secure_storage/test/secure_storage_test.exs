defmodule SecureStorageTest do
  use ExUnit.Case
  doctest SecureStorage

  test "greets the world" do
    assert SecureStorage.hello() == :world
  end
end
