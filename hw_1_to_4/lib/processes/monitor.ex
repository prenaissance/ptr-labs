defmodule Processes.Monitor do
  def start_link do
    spawn_link(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {:monitor, pid} ->
        Process.monitor(pid)
        loop()

      {:DOWN, _ref, :process, pid, reason} ->
        IO.puts("Process #{inspect(pid)} died because of #{inspect(reason)}")
        loop()

      _ ->
        nil
    end
  end

  @spec monitor(pid(), pid()) :: :ok
  def monitor(monitor_pid, child_pid) do
    send(monitor_pid, {:monitor, child_pid})
  end

  @spec spawn_child(pid(), function()) :: pid()
  def spawn_child(monitor_pid, function) do
    child_pid = spawn_link(function)
    monitor(monitor_pid, child_pid)
    child_pid
  end
end
