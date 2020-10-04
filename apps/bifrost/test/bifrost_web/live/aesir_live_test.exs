defmodule BifrostWeb.AesirLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{unauth_conn: conn} do
    description = "Some Description"
    message = "encrypted"
    key = "secret"

    {:ok, uuid} =
      Asguard.insert(
        message,
        key,
        :aes_gcm,
        %{description: description, max_attempts: 1}
      )

    on_exit(fn -> Asguard.delete(uuid) end)

    {:ok, conn: conn, uuid: uuid, key: key}
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

  describe "event: decrypt" do
    test "when decryption is successful", %{conn: conn, uuid: uuid, key: key} do
      {:ok, page_live, _disconnected_html} = live(conn, "/aesirs/#{uuid}")

      html = render_submit(page_live, :decrypt, %{"key" => key, "uuid" => uuid})

      assert html =~ "Showing Secure Data"
      refute html =~ "Encrypted using:"
      assert html =~ "Copy to clipboard"
    end

    test "when decryption is a failure", %{conn: conn, uuid: uuid, key: key} do
      {:ok, page_live, _disconnected_html} = live(conn, "/aesirs/#{uuid}")

      key = key <> "a"

      html = render_submit(page_live, :decrypt, %{"key" => key, "uuid" => uuid})

      assert html =~ "Showing Secure Data"
      assert html =~ "Encrypted using:"
      assert html =~ "Error in decryption"
      refute html =~ "Copy to clipboard"
    end

    test "when not attempts remaining", %{conn: conn, uuid: uuid, key: key} do
      {:ok, page_live, _disconnected_html} = live(conn, "/aesirs/#{uuid}")

      key = key <> "a"

      html = render_submit(page_live, :decrypt, %{"key" => key, "uuid" => uuid})
      assert html =~ "Error in decryption"

      html = render_submit(page_live, :decrypt, %{"key" => key, "uuid" => uuid})
      assert html =~ "No Attempts remaining"
    end
  end
end
