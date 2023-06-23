defmodule Semaphore do
  @type t :: %__MODULE__{count: non_neg_integer, queue: [pid]}
  defstruct count: 1, queue: []

  @spec new(non_neg_integer()) :: Semaphore.t()
  def new(count \\ 1) do
    %Semaphore{count: count, queue: []}
  end

  @spec acquire_sync(__MODULE__.t()) :: {:ok, pid()} | {:wait, pid()}
  def acquire_sync(semaphore) do
    receive do
      {:ok, pid} ->
        {:ok, pid}

      {:wait, pid} ->
        new_semaphore = %__MODULE__{semaphore | queue: semaphore.queue ++ [pid]}
        acquire_sync(new_semaphore)
    end
  end

  @spec release_sync(__MODULE__.t()) :: {:ok, pid()}
  def release_sync(semaphore) do
    new_semaphore = %__MODULE__{semaphore | count: semaphore.count + 1}

    case new_semaphore.queue do
      [] ->
        {:ok, self()}

      [pid | _rest] ->
        send(pid, {:ok, self()})
        {:ok, pid}
    end
  end
end
