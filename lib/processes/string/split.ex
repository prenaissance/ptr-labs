require Logger

defmodule Processes.String.Split do
  use GenServer

  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Starting Split process")
    {:ok, []}
  end

  @impl true
  def handle_call({:split, str}, _from, state) do
    {:reply, String.split(str), state}
  end

  def split(str) do
    GenServer.call(__MODULE__, {:split, str})
  end
end
