defmodule BifrostWeb.APIConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use BifrostWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import BifrostWeb.ConnCase

      alias BifrostWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint BifrostWeb.Endpoint
    end
  end

  setup _tags do
    conn =
      Phoenix.ConnTest.build_conn()
      |> Plug.Conn.put_req_header("content-type", "application/text")

    auth_conn =
      Plug.Conn.put_req_header(
        conn,
        "authorization",
        # Same as configured
        "Bearer test_user:secret"
      )

    {:ok, auth_conn: auth_conn, unauth_conn: conn}
  end
end
