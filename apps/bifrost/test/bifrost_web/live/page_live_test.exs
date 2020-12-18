defmodule BifrostWeb.PageLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest

  import Mox
  alias EncryptedMessagesMock, as: Mock
  alias SecureStorage.Schema.EncryptedMessage

  setup %{auth_conn: conn} do
    description = "Some Description"

    query = description |> String.codepoints() |> Enum.take(4) |> Enum.join()

    stub(Mock, :search_messages, fn
      ^query ->
        [
          %EncryptedMessage{
            id: "some-id",
            state: :encrypted,
            short_description: description,
            encryption_algo: "plain",
            txt: "raw"
          }
        ]

      _ ->
        []
    end)

    {:ok, auth_conn: conn, description: description}
  end

  test "disconnected and connected render", %{auth_conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    app_name = Bifrost.app_name()
    assert disconnected_html =~ "Welcome to #{app_name}"
    assert render(page_live) =~ "Welcome to #{app_name}"
    assert disconnected_html =~ "Heimdall"
    assert disconnected_html =~ "Add Information"
  end

  test "change event: suggest", %{auth_conn: conn, description: description} do
    {:ok, view, _html} = live(conn, "/")

    refute render(view) =~ description
    query = description |> String.codepoints() |> Enum.take(4) |> Enum.join()
    assert render_change(view, :suggest, %{"q" => query}) =~ description
  end

  test "submit event: search", %{auth_conn: conn, description: description} do
    {:ok, view, _html} = live(conn, "/")

    refute render(view) =~ description
    query = description |> String.codepoints() |> Enum.take(4) |> Enum.join()
    assert render_submit(view, :search, %{"q" => query}) =~ description

    refute render_submit(view, :search, %{"q" => "xyz1"}) =~ description
  end
end
