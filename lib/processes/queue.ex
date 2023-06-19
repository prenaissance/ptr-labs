defmodule Processes.Queue do
  use Agent

  @spec start_link(GenServer.options()) :: {:ok, pid()} | {:error, any()}
  def start_link(options) do
    Agent.start_link(fn -> [] end, options)
  end

  @spec push(pid(), any()) :: :ok
  def push(pid, x) do
    Agent.update(pid, fn state -> [x | state] end)
  end

  @spec pop(pid()) :: any()
  def pop(pid) do
    Agent.get_and_update(pid, fn state ->
      case state do
        [] -> {nil, []}
        _ -> {state |> Enum.at(-1), state |> Enum.slice(0..-2)}
      end
    end)
  end
end
