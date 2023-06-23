defmodule Processes.Car.Sensor do
  use GenServer
  require Logger

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  @impl true
  def init(name) do
    Logger.info("Starting Sensor process #{name}")
    {:ok, name}
  end

  @impl true
  def handle_call({:health, _}, _from, state) do
    {:reply, :ok, state}
  end

  def health_check(name) do
    GenServer.call(__MODULE__, {:health, name})
  end
end
