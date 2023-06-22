defmodule Processes.Car.MainSupervisor do
  use Supervisor, name: __MODULE__
  require Logger
  alias Processes.Car.{WheelsSensor, Sensor}

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Logger.info("Starting Main Supervisor")

    children = [
      WheelsSensor,
      %{
        id: Sensor.Cabin,
        start: {Sensor, :start_link, [Sensor.Cabin]}
      },
      %{
        id: Sensor.Motor,
        start: {Sensor, :start_link, [Sensor.Motor]}
      },
      %{
        id: Sensor.Chassis,
        start: {Sensor, :start_link, [Sensor.Chassis]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 3, max_seconds: 60)
  end
end
