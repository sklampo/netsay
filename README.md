# netsay

A ventriloquist application

## About

`netsay` is a simple ventriloquist application.  It allows you to send text to
a remote server, which will then speak the text on that system.

The `netsay` executable contains both the server and client functionality.

The server component depends on the `say` executable, a text-to-speech
synthesizer native to macOS. The client can be run on any machine that has
`ncat` installed, an implementation of Netcat from Nmap.org.

## Requirements

- `say` - macOS text-to-speech tool (server only)
- `ncat` - Netcat implementation from Nmap.org

## Installation (stealth)

You can simply install and run `netsay` by copying the
[`install.sh`](./install.sh) script to your macOS machine.  Then run the script
with the following command:

```shell
nohup bash install.sh &>/dev/null &
```

## Usage

This program contains both the server and client functionality.

### Server

#### Basic startup

```shell
./netsay -s
```

#### Verbose startup

```shell
./netsay -sv
```

#### Shut down running server

```shell
./netsay -k
```

### Client

#### Basic usage

```shell
./netsay -c localhost <<< "hello world"
```

### Example Gallery

#### Hello World, with "Grandpa" voice

```shell
./netsay -c localhost -p 15015 <<< "hello world"
```

#### Dad jokes

```shell
curl -s -H "Accept: text/plain" https://icanhazdadjoke.com/ | ./netsay -c localhost
```

#### Fans of Grogu

```shell
jot -b yes 5 | ./netsay -c localhost -p 15034
```

or

```shell
jot -b yes 5 | ./netsay -c localhost -p 15031
```
