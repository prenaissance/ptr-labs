alias Processes.String.{Split, Joiner, NMSwapper}

defmodule Processes.String.Pipeline do
  use Supervisor, name: Processes.String.Pipeline

  @impl true
  def init(_) do
    children = [
      {Split, []},
      {Joiner, []},
      {NMSwapper, []}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def process(str) do
    Split.split(str)
    |> NMSwapper.swap()
    |> Joiner.join()
  end
end
