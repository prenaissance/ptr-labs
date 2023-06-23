require Logger

defmodule Processes.String.Joiner do
  use GenServer

  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Starting Joiner process")
    {:ok, []}
  end

  @impl true
  def handle_call({:join, words}, _from, state) do
    {:reply, Enum.join(words, " "), state}
  end

  def join(words) do
    GenServer.call(__MODULE__, {:join, words})
  end
end
