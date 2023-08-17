#!/usr/bin/env bash

# -------------------------------------------------------------------------
#
# Configuration
#
# -------------------------------------------------------------------------
EXIT_FAILURE=1
BASE_PORT=15001

# -------------------------------------------------------------------------
#
# Functions
#
# -------------------------------------------------------------------------
function usage() {
  cat << EOT

This is free software with ABSOLUTELY NO WARRANTY.

usage: netsay [options]

  -c

      Specify the host to connect to.  (Client mode only)

  -h

      Display this help message.

  -k

      Shut down the netsay server.

  -p

      Specify the port to use.  Default is ${BASE_PORT}.  (Client mode only)

  -s

      Start the netsay servers.

  -v

      Verbose mode.  Print debug information.

examples:

    Server mode:
    $0 -s

    Client:
    echo "hello" | $0 -c remote

EOT
}

function abort() {
  [[ -n "${1}" ]] && echo "${1}"
  exit "${EXIT_FAILURE}"
}

function debug() {
  [[ -n "${verbose}" ]] && echo "${1}"
}

function netsay_server() {
  [[ -z "${1}" ]] && abort "Missing required port argument"
  [[ -n "${2}" ]] && say_options="-v ${2}" || say_options=""

  debug_message="Starting netsay on port ${1}"
  [[ -n "${2}" ]] && debug_message="${debug_message} with voice ${2}"
  debug "${debug_message}"

  nohup ncat -l "$1" -c "/usr/bin/say ${say_options}" --keep-open --max-conns 2 < /dev/null > /dev/null &
}

function shutdown() {
   pkill -l -f "^ncat -l.*-c /usr/bin/say"
}

function netsay_server_fleet() {
  netsay_server "${port}"
  voices_port=$((port+1))
  for voice in $(english_voices); do
    netsay_server "${voices_port}" "${voice}"
    ((voices_port=voices_port+1))
  done
}

function port_ready() {
  if [[ -n "${verbose}" ]]; then
    nc -z -w 1  "${1}" "${2}"
  else
    nc -v -z -w 1 "${1}" "${2}" > /dev/null 2>&1
  fi
}

function netsay_client() {
  port_ready "${1}" "${2}" || abort "No netsay server listing to port ${2} on host ${1}"

  cat | ncat "${1}" "${2}"
}

function preflight_checks() {
  which ncat > /dev/null 2>&1 || abort "Missing required ncat executable.  Install via 'brew install nmap'."
}

function english_voices() {
  say -v \? | sed 's/#.*$//;/^$/d' | awk '$NF ~ /en_/ { print $1}' | sort -u
}

# -------------------------------------------------------------------------
#
# Main
#
# -------------------------------------------------------------------------

preflight_checks

while getopts ":c:hkp::sv" o; do
  case "${o}" in
    c)
      c=${OPTARG}
      mode="client"
      ;;
    h)
      usage
      exit
      ;;
    k)
      echo "Shutting down netsay server ..."
      shutdown || abort
      ;;
    p)
      port=${OPTARG}
      ;;
    s)
      mode="server"
      ;;
    v)
      verbose=1
      set -x
      ;;
    *)
      echo "Unrecognized argument"
      usage
      ;;
  esac
done
shift $((OPTIND-1))

[[ -z "${port}" ]] && port="${BASE_PORT}"

if [[ "${mode}" == "server" ]]; then
  debug "Starting netsay in server mode"
  netsay_server_fleet
elif [[ "${mode}" == "client" ]]; then
  debug "Connecting to netsay server ${c} on port ${port} ..."
  netsay_client "${c}" "${port}"
else
  usage
  abort
fi
