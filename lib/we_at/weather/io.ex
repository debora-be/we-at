defmodule WeAt.Weather.IO do
  @moduledoc """
  Input/Output module for WeAt with custom I/O handling.
  """

  @doc """
  Starts the WeAt application.
  """
  @spec run() :: :ok
  def run do
    :io.format("Welcome to WeAt!~n The wheather from the whole world really quickly!~n")
    start_weather_fetching()
  end

  defp start_weather_fetching do
    :io.format("Enter the name of a city to get weather information (or type 'exit' to quit):~n")

    case :io.get_line("> ") do
      :eof ->
        :io.format("No input provided. Exiting.~n")
        :ok

      "exit\n" ->
        :io.format("Exiting WeAt.~n")
        :ok

      city ->
        city
        |> String.trim()
        |> fetch_and_display_weather()

        start_weather_fetching()
    end
  end

  defp fetch_and_display_weather(city) do
    case WeAt.Weather.Cache.get_weather(city) do
      %{"name" => city} = weather_data ->
        display_weather(weather_data)

      _ ->
        :io.format("oops! no data for #{city}~n, let's try again?~n")
    end
  end

  defp display_weather(weather) do
    lat = Float.to_string(weather["coord"]["lat"])
    lon = Float.to_string(weather["coord"]["lon"])

    :io.format("Weather data for ~s:~n", [weather["name"]])
    :io.format("  Coordinates: Latitude ~s, Longitude ~s~n", [lat, lon])

    :io.format("  Weather: ~s~n", [
      Enum.map(weather["weather"], fn w -> w["description"] end) |> Enum.join(", ")
    ])

    :io.format("  Temperature: ~.2f°C~n", [weather["main"]["temp"] - 273.15])
    :io.format("  Feels like: ~.2f°C~n", [weather["main"]["feels_like"] - 273.15])
    :io.format("  Pressure: ~p hPa~n", [weather["main"]["pressure"]])
    :io.format("  Humidity: ~w%%~n", [weather["main"]["humidity"]])
    :io.format("  Wind Speed: ~.2f m/s~n", [weather["wind"]["speed"]])
    :io.format("  Cloudiness: ~w%%~n", [weather["clouds"]["all"]])

    :io.format("  Sunrise: ~s~n", [
      unix_to_datetime(weather["sys"]["sunrise"], weather["timezone"])
    ])

    :io.format("  Sunset: ~s~n", [unix_to_datetime(weather["sys"]["sunset"], weather["timezone"])])
  end

  defp unix_to_datetime(unix_time, timezone_offset) do
    unix_time
    |> Kernel.+(timezone_offset)
    |> DateTime.from_unix!(:second)
    |> DateTime.to_string()
  end
end
