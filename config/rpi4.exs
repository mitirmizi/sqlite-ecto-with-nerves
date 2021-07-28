# configs for rpi4
import Config
# template for the line below is: config :app_name, led_list: [:green, :red]
config :sqlite_nerves, led_list: [:green, :red]
config :nerves_leds, names: [green: "led0", red: "led1"]

config :sqlite_nerves, SqliteNerves.Repo,
   database: "/root/#{Mix.env}_db_name.sqlite3"
