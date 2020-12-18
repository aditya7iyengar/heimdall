defmodule BifrostWeb.EncryptedMessageLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest

  import Mox
  alias EncryptedMessagesMock, as: Mock
  alias SecureStorage.Schema.EncryptedMessage

  setup %{unauth_conn: conn} do
    id = "some=id"

    stub(Mock, :get_message, fn _ ->
      %EncryptedMessage{
        id: id,
        state: :encrypted,
        short_description: "Description",
        encryption_algo: "plain",
        txt: "raw"
      }
    end)

    stub(Mock, :decrypt_message, fn
      _, "valid-key" -> "supersecretmessage"
      _, "decryption_error" -> {:error, :decryption_error}
      _, "no_attempts_remaining" -> {:error, :no_attempts_remaining}
      _, "no_reads_remaining" -> {:error, :no_reads_remaining}
    end)

    {:ok, conn: conn, id: id}
  end

  test "disconnected and connected render", %{conn: conn, id: id} do
    {:ok, page_live, disconnected_html} = live(conn, "/encrypted_messages/#{id}")
    assert disconnected_html =~ "Showing Secure Data"
    assert disconnected_html =~ "Encrypted using:"
    refute disconnected_html =~ "Copy to clipboard"

    assert render(page_live) =~ "Showing Secure Data"
    assert render(page_live) =~ "Encrypted using:"
    refute render(page_live) =~ "Copy to clipboard"
  end

  describe "event: decrypt" do
    test "when decryption is successful", %{conn: conn, id: id} do
      {:ok, page_live, _disconnected_html} = live(conn, "/encrypted_messages/#{id}")

      html = render_submit(page_live, :decrypt, %{"key" => "valid-key", "id" => id})

      assert html =~ "Showing Secure Data"
      refute html =~ "Encrypted using:"
      assert html =~ "Copy to clipboard"
    end

    test "when decryption is a failure", %{conn: conn, id: id} do
      {:ok, page_live, _disconnected_html} = live(conn, "/encrypted_messages/#{id}")

      html = render_submit(page_live, :decrypt, %{"key" => "decryption_error", "id" => id})

      assert html =~ "Showing Secure Data"
      assert html =~ "Encrypted using:"
      assert html =~ "Error in decryption"
      refute html =~ "Copy to clipboard"
    end

    test "when no attempts remaining", %{conn: conn, id: id} do
      {:ok, page_live, _disconnected_html} = live(conn, "/encrypted_messages/#{id}")

      html = render_submit(page_live, :decrypt, %{"key" => "no_attempts_remaining", "id" => id})

      assert html =~ "No Attempts remaining"
    end

    test "when no reads remaining", %{conn: conn, id: id} do
      {:ok, page_live, _disconnected_html} = live(conn, "/encrypted_messages/#{id}")

      html = render_submit(page_live, :decrypt, %{"key" => "no_reads_remaining", "id" => id})

      assert html =~ "No Reads remaining"
    end
  end

  describe "event: show/hide" do
    test "with decrypted show/hide", %{conn: conn, id: id} do
      {:ok, page_live, _disconnected_html} = live(conn, "/encrypted_messages/#{id}")

      html = render_submit(page_live, :decrypt, %{"key" => "valid-key", "id" => id})

      assert html =~ "Showing Secure Data"

      # Shows proper buttons
      assert html =~ "Show"
      refute html =~ "Hide"

      html = render_click(page_live, :show)

      assert html =~ "Hide"

      html = render_click(page_live, :hide)

      assert html =~ "Show"
      refute html =~ "Hide"
    end
  end
end
