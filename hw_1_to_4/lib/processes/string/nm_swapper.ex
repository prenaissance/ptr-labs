require Logger

defmodule Processes.String.NMSwapper do
  use GenServer

  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Starting NMSwapper process")
    {:ok, []}
  end

  defp swap_n_and_m(word) do
    word
    |> String.split("")
    |> Enum.map(fn
      "n" -> "m"
      "m" -> "n"
      x -> x
    end)
    |> Enum.join("")
  end

  @impl true
  def handle_call({:swap, words}, _from, state) do
    {:reply, words |> Enum.map(&String.downcase/1) |> Enum.map(&swap_n_and_m/1), state}
  end

  def swap(str) do
    GenServer.call(__MODULE__, {:swap, str})
  end
end
