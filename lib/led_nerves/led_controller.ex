defmodule LedNerves.LedController do

  @app_name Mix.Project.config[:app]
  @on_duration 200
  @off_duration 50

  require Logger
  alias Nerves.Leds

  def blink_ntimes(1), do: blink_leds()
  def blink_ntimes(n) when is_number(n) and n > 0 do
    blink_leds()
    blink_ntimes(n - 1)
  end

  def blink_leds() do
    leds = led_list()
    IO.inspect( "blinking Led, Led keys: #{inspect leds}")
    Enum.each( leds, fn x -> blink_once(x) end )
  end

  def blink_once(led_key) do
    IO.inspect( "Blink #{led_key} once" )
    Leds.set( [ {led_key, true} ] )  # Passing in a keyword list
    :timer.sleep(@on_duration)
    Leds.set( [ {led_key, false} ] )  # Passing in a keyword list
    :timer.sleep(@off_duration)
  end

  def on() do
    IO.inspect("===> Debugging :) <===")
    Logger.info("Enabling LED (curtesy logger)")
    leds = led_list()
    IO.inspect(leds)
    # Enum.each(leds, &set_led(&1, true))
    Enum.each(leds, fn x -> set_led(x, true) end )
  end

  def off() do
    leds = led_list()
    Enum.each(leds, &set_led(&1, false))
  end

  defp set_led(led_key, value) do
    Leds.set( [ {led_key, value} ] )
  end

  defp led_list() do
    Application.get_env(@app_name, :led_list)
  end

end
