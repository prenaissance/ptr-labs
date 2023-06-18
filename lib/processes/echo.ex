defmodule Processes.Echo do
  def start_link do
    spawn_link(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {:echo, msg} ->
        IO.puts(msg)
        loop()

      _ ->
        nil
    end
  end
end
