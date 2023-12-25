defmodule WeAt.Weather.FetcherTest do
  use ExUnit.Case, async: false
  import Mock

  describe "fetch_weather/1" do
    test "handles error for an invalid city" do
      with_mock HTTPoison,
        get: fn _url -> {:ok, %{status_code: 404, body: "Not Found"}} end do
        assert {:error, _} = WeAt.Weather.Fetcher.run("invalid_city")
      end
    end
  end
end
