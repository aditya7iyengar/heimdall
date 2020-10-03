defmodule BifrostWeb.AesirControllerTest do
  use BifrostWeb.ConnCase

  @valid_aesir_params %{
    "raw" => "Raw",
    "key" => "key",
    "description" => "Some description",
    "encryption_algo" => "plain",
    "ttl" => 5
  }

  describe "new/2" do
    test "renders the new.html template", %{auth_conn: conn} do
      conn = get(conn, Routes.aesir_path(conn, :new))

      # TODO: Test more using floki
      assert html_response(conn, 200) =~ "Insert Secure Data"
    end
  end

  describe "create/2" do
    test "adds aesir to Asguard and redirects to root", %{auth_conn: conn} do
      conn =
        post(
          conn,
          Routes.aesir_path(conn, :create),
          aesir: @valid_aesir_params
        )

      on_exit(fn ->
        [aesir] = Asguard.search(@valid_aesir_params["description"])
        Asguard.delete(aesir.uuid)
      end)

      assert html_response(conn, 302) =~ "redirected"
      assert conn.private.plug_session["phoenix_flash"]["info"] =~ "Inserted"
    end

    test "adds aesir to Asguard (with binary ttl)", %{auth_conn: conn} do
      conn =
        post(
          conn,
          Routes.aesir_path(conn, :create),
          aesir: Map.put(@valid_aesir_params, "ttl", "5")
        )

      on_exit(fn ->
        [aesir] = Asguard.search(@valid_aesir_params["description"])
        Asguard.delete(aesir.uuid)
      end)

      assert html_response(conn, 302) =~ "redirected"
      assert conn.private.plug_session["phoenix_flash"]["info"] =~ "Inserted"
    end

    # TODO: This test isn't working. Find a way to test failures
    @tag :skip
    test "flashes error when insert is unsuccessful", %{auth_conn: conn} do
      on_exit(fn -> Asguard.start_link([]) end)

      # This is to make it stop
      :ok = GenServer.stop(Asguard)

      conn =
        post(
          conn,
          Routes.aesir_path(conn, :create),
          aesir: @valid_aesir_params
        )

      assert html_response(conn, 302) =~ "redirected"
      assert conn.private.plug_session["phoenix_flash"]["error"] =~ "Error"
    end
  end
end
