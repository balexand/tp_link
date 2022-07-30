# TpLink

[![Package](https://img.shields.io/hexpm/v/tp_link.svg)](https://hex.pm/packages/tp_link) [![Documentation](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/tp_link) ![CI](https://github.com/balexand/tp_link/actions/workflows/elixir.yml/badge.svg)

Client library for interacting with Kasa/TP-Link smart home devices via either tplinkcloud.com or
directly over the local network (no Internet connection required).

## Installation

The package can be installed by adding `tp_link` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tp_link, "~> 0.1.0"}
  ]
end
```

## Usage

### Cloud

Create a session by calling [`TpLink.Cloud.login`](https://hexdocs.pm/tp_link/TpLink.Cloud.html#login/2):

```elixir
{:ok, session} = TpLink.Cloud.login("user@example.com", "password")
```

To list devices, call [`TpLink.Cloud.list_devices`](https://hexdocs.pm/tp_link/TpLink.Cloud.html#list_devices/1):

```elixir
{:ok, devices} = TpLink.Cloud.list_devices(session)
```

Using the `device_id` returned by the previous call, you can turn on a smart switch by calling:

```elixir
session
|> TpLink.cloud_device("800626A81D45A54544ADE5222EB50BF11BB7CBE3")
|> TpLink.Type.Plug.set_relay_state(true)
```

### Local network

To list devices on the local network, call [`TpLink.Local.list_devices`](https://hexdocs.pm/tp_link/TpLink.Local.html#list_devices/1). There is no need to authenticate because TP-Link devices are not secure on the local network:

```elixir
{:ok, devices} = TpLink.Local.list_devices()
```

Using the IP address or hostname of the device, you can turn on a smart switch by calling:

```elixir
TpLink.local_device({192, 168, 0, 3})
|> TpLink.Type.Plug.set_relay_state(true)
```
