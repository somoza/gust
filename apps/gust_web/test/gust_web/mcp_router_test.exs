defmodule GustWeb.MCPRouterTest do
  use GustWeb.ConnCase, async: true

  @mcp_paths [
    "/mcp/server",
    "/mcp/server/.well-known/oauth-authorization-server"
  ]

  test "gust_mcp_server/0 defines MCP routes inside a scope" do
    module = mcp_router()

    paths =
      module.__routes__()
      |> Enum.map(& &1.path)

    Enum.each(@mcp_paths, fn path ->
      assert path in paths
    end)
  end

  defp mcp_router do
    module = Module.concat(__MODULE__, "TestRouter#{System.unique_integer([:positive])}")

    {:module, ^module, _, _} =
      Module.create(
        module,
        quote do
          use Phoenix.Router
          import GustWeb.MCPRouter

          pipeline :api do
            plug :accepts, ["json"]
          end

          scope "/mcp" do
            pipe_through :api
            gust_mcp_server()
          end
        end,
        Macro.Env.location(__ENV__)
      )

    module
  end
end
