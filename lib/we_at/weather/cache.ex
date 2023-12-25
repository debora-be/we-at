defmodule WeAt.Weather.Cache do
  use GenServer

  @name :we_at_cache
  @ets_table :weather_data

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    # Create the ETS table if it does not already exist
    :ets.new(@ets_table, [:named_table, :set, :public])
    {:ok, %{}}
  end

  def get_weather(city) do
    ensure_started()
    GenServer.call(@name, {:get_weather, city})
  end

  def handle_call({:get_weather, city}, _from, state) do
    case :ets.lookup(@ets_table, city) do
      [{_city, weather}] ->
        {:reply, weather, state}

      [] ->
        case WeAt.Weather.Fetcher.run(city) do
          {:ok, weather} ->
            :ets.insert(@ets_table, {city, weather})
            {:reply, weather, state}

          {:error, reason} ->
            {:reply, {:error, reason}, state}
        end
    end
  end

  defp ensure_started do
    unless Process.whereis(@name) do
      {:ok, _pid} = start_link()
    end
  end
end
