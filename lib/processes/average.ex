defmodule Processes.Average do
  @spec print_average([number]) :: :ok
  defp print_average(state) do
    average =
      case state do
        [] -> 0
        _ -> Enum.sum(state) / length(state)
      end

    IO.puts("Average: #{average}")
  end

  @spec start_link([number]) :: pid()
  def start_link(initial_state \\ []) do
    spawn_link(__MODULE__, :loop, [initial_state])
  end

  @spec loop([number]) :: any
  def loop(state) do
    print_average(state)

    receive do
      x ->
        loop([x | state])
    end
  end

  @spec push(pid(), number) :: :ok
  def push(pid, x) do
    send(pid, x)
  end
end
