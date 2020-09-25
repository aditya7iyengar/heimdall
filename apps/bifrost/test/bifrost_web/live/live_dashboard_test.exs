defmodule BifrostWeb.LiveDashboardTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{auth_conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/dashboard/nonode%40nohost/home")
    assert disconnected_html =~ "LiveDashboard"
    assert render(page_live) =~ "LiveDashboard"
  end
end
