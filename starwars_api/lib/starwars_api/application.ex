defmodule StarwarsApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: StarwarsApi.Router,
       options: [port: Application.get_env(:starwars_api, :port, 8080)]},
      {
        Mongo,
        [
          url:
            Application.get_env(
              :starwars_api,
              :database_url,
              "mongodb://localhost:27017/starwars"
            ),
          name: :mongo,
          pool_size: Application.get_env(:starwars_api, :pool_size, 3)
        ]
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StarwarsApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
