defmodule WeAt.Weather.IO.Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "main/0" do
    test "displays welcome message and calls start_weather_fetching/0" do
      output =
        capture_io(fn ->
          WeAt.Weather.IO.run()
        end)

      assert "Welcome to WeAt!\n The wheather from the whole world really quickly!\nEnter the name of a city to get weather information (or type 'exit' to quit):\n> No input provided. Exiting.\n" ==
               output
    end

    test "displays weather information for a valid city" do
      input = "London\nPorto Alegre\nexit\n"

      output =
        capture_io(input, fn ->
          WeAt.Weather.IO.run()
        end)

      assert String.contains?(output, "Weather data for London:")
      assert String.contains?(output, "Weather data for Porto Alegre:")
      assert String.contains?(output, "Exiting WeatherApp.")
    end

    test "exits when 'exit' is provided as input" do
      input = "exit\n"

      output =
        capture_io(input, fn ->
          WeAt.Weather.IO.run()
        end)

      assert String.contains?(output, "Exiting WeatherApp.")
    end

    test "handles 'No input provided' message and exits" do
      input = "\n"

      output =
        capture_io(input, fn ->
          WeAt.Weather.IO.run()
        end)

      assert String.contains?(output, "No input provided. Exiting.")
    end

    test "handles invalid city input and prompts for retry" do
      input = "Invalid City\nexit\n"

      output =
        capture_io(input, fn ->
          WeAt.Weather.IO.run()
        end)

      assert String.contains?(output, "oops! no data for Invalid City")
      assert String.contains?(output, "let's try again?")
      assert String.contains?(output, "Exiting WeatherApp.")
    end
  end
end
