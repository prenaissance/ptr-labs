defmodule Processes.Car.WheelsSensor do
  use GenServer
  require Logger
  alias Processes.Car.Sensor

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Logger.info("Starting Wheels Sensor Process")

    children = [
      %{
        id: Sensor.Wheel1,
        start: {Sensor, :start_link, [Sensor.Wheel1]}
      },
      %{
        id: Sensor.Wheel2,
        start: {Sensor, :start_link, [Sensor.Wheel2]}
      },
      %{
        id: Sensor.Wheel3,
        start: {Sensor, :start_link, [Sensor.Wheel3]}
      },
      %{
        id: Sensor.Wheel4,
        start: {Sensor, :start_link, [Sensor.Wheel4]}
      }
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: Processes.Car.WheelsSensorSupervisor,
      max_restarts: 1
    )

    {:ok, []}
  end

  @impl true
  def handle_call({:health, _}, _from, state) do
    {:reply, :ok, state}
  end

  def health_check(name) do
    GenServer.call(__MODULE__, {:health, name})
  end
end
