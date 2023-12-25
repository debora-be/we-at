defmodule WeAt.Weather.Fetcher do
  @moduledoc """
  Fetches weather data from OpenWeatherMap.
  """
  require Logger

  @doc """
  Fetches weather data for a given city.
  """
  @spec run(String.t()) :: {:ok, map()} | {:error, term()}
  def run(city) do
    url = build_url(city)

    with {:ok, %_{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, decoded} <- Jason.decode(body) do
      {:ok, decoded}
    else
      {:ok, %_{status_code: status_code}} ->
        Logger.warning("[WeatherFetcher]returned status code: #{status_code}")
        {:error, :unexpected_status_code}

      {:error, %_{reason: reason}} ->
        Logger.warning("[WeatherFetcher] could not retrieve weather data: #{inspect(reason)}")
        {:error, reason}

      _ ->
        {:error, :unknown_error}
    end
  end

  defp config do
    Application.fetch_env!(:we_at, WeatherFetcher)
  end

  defp build_url(city) do
    config = config()
    api_key = config[:api_key]
    base_url = config[:base_url]

    "#{base_url}?q=#{city}&APPID=#{api_key}"
  end
end
