defmodule BifrostWeb.ErrorViewTest do
  use BifrostWeb.ConnCase, async: true

  @module BifrostWeb.ErrorView

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(BifrostWeb.ErrorView, "404.html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(BifrostWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end

  describe "template_not_found/2" do
    test "works as expected" do
      template = "404.html"
      assert @module.template_not_found(template, %{}) == "Not Found"
    end
  end
end
