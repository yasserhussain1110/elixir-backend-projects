defmodule ApiRequestHeader.ApiController do
  use ApiRequestHeader.Web, :controller

  def get_os_and_browser(conn) do
    %{family: browser, os: %{family: os}} =
      conn
      |> Plug.Conn.get_req_header("user-agent")
      |> List.first()
      |> UAParser.parse()

    %{browser: browser, os: os}
  end

  def get_ip_address(conn) do
    forwarded_for = Plug.Conn.get_req_header(conn, "x-forwarded-for")
    if forwarded_for == '' do
      conn.remote_ip |> Tuple.to_list |> Enum.join(".")
    else
      List.first forwarded_for
    end
  end

  def show(conn, _params) do
    user_agent_info = Map.put(get_os_and_browser(conn), :ip, get_ip_address(conn))
    json conn, user_agent_info
  end
end
