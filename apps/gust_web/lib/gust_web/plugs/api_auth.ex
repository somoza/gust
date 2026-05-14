defmodule GustWeb.Plugs.APIAuth do
  @moduledoc """
  Authenticates Gust API requests with the configured bearer token.
  """

  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- token_valid?(token) do
      conn
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "unauthorized"})
        |> halt()
    end
  end

  defp token_valid?(token) when is_binary(token) do
    case Application.get_env(:gust_web, :api_token) do
      configured_token when is_binary(configured_token) and configured_token != "" ->
        byte_size(token) == byte_size(configured_token) and
          Plug.Crypto.secure_compare(token, configured_token)

      _ ->
        false
    end
  end
end
