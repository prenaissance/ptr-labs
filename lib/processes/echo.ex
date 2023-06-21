require Logger

defmodule Processes.Echo do
  def child_spec(_opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }

  def start_link do
    Logger.info("Starting Echo process")
    spawn_link(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      msg ->
        IO.puts(msg)
        loop()
    end

    loop()
  end

  def echo(pid, msg) do
    send(pid, msg)
  end
end
