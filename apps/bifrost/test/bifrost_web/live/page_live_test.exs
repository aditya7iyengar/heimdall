defmodule BifrostWeb.PageLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    app_name = Bifrost.app_name()
    assert disconnected_html =~ "Welcome to #{app_name}"
    assert render(page_live) =~ "Welcome to #{app_name}"
  end
end
