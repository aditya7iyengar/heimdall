defmodule BifrostWeb.AesirLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{unauth_conn: conn} do
    description = "Some Description"
    encrypted = "encrypted"
    uuid = "cdfdaf44-ee35-11e3-846b-14109ff1a304"

    inserted_aesir = %Asguard.Aesir{
      description: description,
      encrypted: encrypted,
      encryption_algo: :plaintext,
      uuid: uuid,
      iat: DateTime.utc_now(),
      exp: DateTime.utc_now()
    }

    uuid = GenServer.call(Asguard, {:insert, inserted_aesir})

    on_exit(fn -> Asguard.delete(uuid) end)

    {:ok, conn: conn, uuid: uuid}
  end

  test "disconnected and connected render", %{conn: conn, uuid: uuid} do
    {:ok, page_live, disconnected_html} = live(conn, "/aesirs/#{uuid}")
    assert disconnected_html =~ "Showing Secure Data"
    assert disconnected_html =~ "Encrypted using:"
    refute disconnected_html =~ "Copy to clipboard"

    assert render(page_live) =~ "Showing Secure Data"
    assert render(page_live) =~ "Encrypted using:"
    refute render(page_live) =~ "Copy to clipboard"
  end

  test "event: decrypt", %{conn: conn, uuid: uuid} do
    {:ok, page_live, _disconnected_html} = live(conn, "/aesirs/#{uuid}")

    html = render_submit(page_live, :decrypt, %{"key" => "key", "uuid" => uuid})

    assert html =~ "Showing Secure Data"
    refute html =~ "Encrypted using:"
    assert html =~ "Copy to clipboard"
  end
end
