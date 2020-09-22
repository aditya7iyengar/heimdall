defmodule BifrostWeb.PageLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    auth_conn =
      put_req_header(
        conn,
        "authorization",
        # Same as configured
        Plug.BasicAuth.encode_basic_auth("test_user", "secret")
      )

    %{auth_conn: auth_conn}
  end

  test "disconnected and connected render", %{auth_conn: auth_conn} do
    {:ok, page_live, disconnected_html} = live(auth_conn, "/")
    app_name = Bifrost.app_name()
    assert disconnected_html =~ "Welcome to #{app_name}"
    assert render(page_live) =~ "Welcome to #{app_name}"
  end
end
