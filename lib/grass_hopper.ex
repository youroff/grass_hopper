defmodule GrassHopper do
  @moduledoc """
  GrassHopper is a tiny abstraction over GenServer, that helps building
  dynamically scheduled recursive processes. It allows to efficiently jump
  along timestamps and perform user defined actions. Think of a librarian
  going through the list of borrowed books and calling the borrowers
  as their leases reach the due date.

  User of GrassHopper needs to implement two callbacks:

  - `next` is called to compute the next timestamp (NaiveDateTime) or nil which will cause
    the process to wait indefinitely or max_timeout
  - `perform`: called to perform the operation on a given interval
  """

  @type state :: %{
    opts: Keyword.t,
    from: NaiveDateTime.t,
    to: NaiveDateTime.t
  }

  @callback perform(state) :: any
  @callback next(state) :: NaiveDateTime.t | nil

  defmacro __using__(global_opts \\ []) do
    quote do
      use GenServer
      @behaviour GrassHopper
      @dialyzer {:no_match, [{:handle_continue, 2}]}

      def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      @impl true
      def init(local_opts \\ []) do
        opts = Keyword.merge(unquote(global_opts), local_opts)

        timestamp = Keyword.get_lazy(opts, :start_time, fn ->
          NaiveDateTime.utc_now()
        end)
        state = %{opts: opts, from: timestamp, to: timestamp}
        {:ok, state, {:continue, []}}
      end

      @impl true
      def next(_), do: nil

      @impl true
      def handle_continue(_, state) do
        now = NaiveDateTime.utc_now()
        ts = __MODULE__.next(state)
        timeout = if is_nil(ts) do
          :infinity
        else
          NaiveDateTime.diff(ts, now, :millisecond)
        end

        case GrassHopper.trim_timeout(timeout, state.opts) do
          :infinity ->
            {:noreply, state}
          timeout ->
            new_state = %{state | to: NaiveDateTime.add(now, timeout, :millisecond)}
            {:noreply, new_state, timeout}
        end
      end

      @impl true
      def handle_info(:timeout, state) do
        __MODULE__.perform(state)
        {:noreply, %{state | from: state.to}, {:continue, []}}
      end

      def handle_info(:refresh, state) do
        {:noreply, state, {:continue, []}}
      end

      defoverridable next: 1
    end
  end

  @spec refresh(atom) :: any
  def refresh(dest) do
    # TODO: Make it work with distributed actors
    if pid = Process.whereis(dest) do
      send(pid, :refresh)
    end
  end

  @spec trim_timeout(timeout, Keyword.t) :: timeout
  def trim_timeout(timeout, opts \\ []) do
    case timeout do
      :infinity ->
        Keyword.get(opts, :max_timeout, :infinity)
      timeout ->
        upper = Keyword.get(opts, :min_timeout, 0) |> max(timeout)
        Keyword.get(opts, :max_timeout, upper) |> min(upper)
    end
  end
end
