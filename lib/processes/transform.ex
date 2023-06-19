defmodule Processes.Transform do
  def start_link do
    spawn_link(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {x, parent} ->
        send(
          parent,
          "Received: #{cond do
            is_number(x) -> x + 1
            is_binary(x) -> String.downcase(x)
            true -> "I don't know how to HANDLE this!"
          end}"
        )

        loop()
    end
  end

  @spec transform(pid(), any(), pid()) :: :ok
  def transform(pid, msg, parent \\ self()) do
    send(pid, {msg, parent})
  end
end
