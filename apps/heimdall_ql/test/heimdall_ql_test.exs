defmodule HeimdallQLTest do
  use ExUnit.Case

  @module HeimdallQL

  describe "init/1" do
    test "returns opts" do
      opts = []
      assert opts == @module.init(opts)
    end
  end

  describe "call/2" do
    setup do
      conn = %Plug.Conn{}

      auth_conn =
        Plug.Conn.put_req_header(
          conn,
          "authorization",
          "Bearer test_user:secret"
        )

      {:ok, conn: conn, auth_conn: auth_conn}
    end

    test "returns halted conn when unauthoried", %{conn: conn} do
      new_conn = @module.call(conn, nil)

      assert new_conn.halted
      assert new_conn.status == 401
    end

    test "returns a non-halted conn when authorized", %{auth_conn: conn} do
      new_conn = @module.call(conn, nil)

      refute new_conn.halted

      expected_header = {"authorization", "Bearer test_user:secret"}
      assert Enum.member?(new_conn.req_headers, expected_header)
    end
  end
end
