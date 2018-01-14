defmodule TraxWeb.GameWebsocketListener do
  use GenServer

  alias __MODULE__, as: This

  def start_link() do
    opts = [name: :game_websocket_listener]
    GenServer.start_link(This, :args, opts)
  end


  def init(:args) do
    port = Application.get_env(:trax_web, :websocket_port)
    if is_integer(port) do
      #TODO think about keeping an eye out on cowboy in case it dies
      dispatch_config = build_dispatch_config()

      acceptor_count = 100
      transport_opts = [port: port]
      protocol_opts = [env: [dispatch: dispatch_config]]

      with {:ok, _pid} <- :cowboy.start_http(:http, acceptor_count, transport_opts, protocol_opts)
      do
        {:ok, :state}
      else
        err -> {:stop, {:could_not_start_cowboy, err}}
      end
    else
      {:stop, :websocket_port_missing_in_config}
    end
  end


  def build_dispatch_config() do
    :cowboy_router.compile([
      {
        :_,
        [
          {"/websocket", TraxWeb.GameWebsocketHandler, []}
        ]
      }
    ])
  end

end
