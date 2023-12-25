defmodule WeAt.Weather.CacheTest do
  use ExUnit.Case, async: false
  import Mock

  setup do
    {:ok, _pid} = WeAt.Weather.Cache.start_link()
    :ok
  end

  test "get_weather fetches and caches weather data for a new city" do
    city = "NewCity"
    weather_data = %{"temperature" => 25, "weather" => "sunny"}

    with_mock WeAt.Weather.Fetcher, run: fn ^city -> {:ok, weather_data} end do
      fetched_weather = WeAt.Weather.Cache.get_weather(city)
      assert fetched_weather == weather_data
      assert :ets.lookup(:weather_data, city) == [{city, weather_data}]
    end
  end

  test "get_weather retrieves cached weather data for a known city" do
    city = "KnownCity"
    weather_data = %{"weather" => "rainy", "temperature" => 18}
    :ets.insert(:weather_data, {city, weather_data})

    with_mock WeAt.Weather.Fetcher, run: fn _ -> {:error, :not_called} end do
      cached_weather = WeAt.Weather.Cache.get_weather(city)
      assert cached_weather == weather_data
    end
  end

  test "get_weather returns error if WeAt.Weather.Fetcher fails" do
    city = "UnknownCity"
    error = {:error, :not_found}

    with_mock WeAt.Weather.Fetcher, run: fn ^city -> error end do
      assert WeAt.Weather.Cache.get_weather(city) == error
    end
  end
end
