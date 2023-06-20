defmodule(Processes.Risky)

def start_link do
  spawn_link(__MODULE__, :scheduler, [])
end

def scheduler do
  receive do
    {:task, caller_pid} ->
      worker_pid = spawn_link(&worker/0)
      send(worker_pid, caller_pid)
      scheduler()

    :ok ->
      IO.puts("Task success")
      scheduler()
  end
end

defp worker do
  caller_pid =
    receive do
      caller_pid -> caller_pid
    end

  if fail?() do
    IO.puts("Task fail")
    send(caller_pid, :fail)
  else
    IO.puts("Task success")
    send(caller_pid, :ok)
  end

  defp fail? do
    :rand.uniform() < 0.5
  end
end
