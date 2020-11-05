# Using Sqlite3 and Ecto with Elixir Nerves

This repository is to host a basic tutorial for absolute beginners in Elixir and Nerves world, who
want to implment an SQLite database on their embedded device.

Refer to [this tutorial](tutorial.md) for learning all the nitigrities about setting a base Nerves 
project, in which you can ssh and push OTA updates, and setting a base sqlite database.

The main library we'll be using is this [sqlite_ecto2](https://github.com/elixir-sqlite/sqlite_ecto2)

### Instructions to run cloned Repo

1. Change add your network's credentials in `target.exs`
2. `export MIX_TARTGET=rpi4`
3. `mix deps.get`
4. To burn the firmware on SD card, insert your SD card in the computer then
`mix firmware.burn`
If it says cannot detect SD card: for linux use command `mix firmware.burn -d <location of SD card>` in 
my case it was `/dev/mmcblk0` you can check your from Disks utility in Ubuntu.
`mix firmware.burn -d /dev/mmcblk0`