#!/usr/bin/env bash

# -------------------------------------------------------------------------
#
# Configuration
#
# -------------------------------------------------------------------------
EXIT_FAILURE=1

# -------------------------------------------------------------------------
#
# Functions
#
# -------------------------------------------------------------------------
function usage() {
  cat << EOT
  Usage:

    Server mode:
    $0 -s

    Client:
    echo "hello" | $0 -c remote

EOT
}

function abort () {
  [[ -n "${1}" ]] && echo "${1}"
  exit "${EXIT_FAILURE}"
}

function netsay_server() {
  echo "Starting up netsay on port 1111"
  nohup ncat -l 1111 -c '/usr/bin/say' --keep-open < /dev/null > /dev/null &
}

function netsay_client() {
  cat | ncat "${1}" "${2}"
}

function preflight_checks() {
  which ncat > /dev/null 2>&1 || abort "Missing required ncat executable.  Install via 'brew install nmap'."
}

# -------------------------------------------------------------------------
#
# Main
#
# -------------------------------------------------------------------------

preflight_checks

while getopts ":c:p::s" o; do
  case "${o}" in
    c)
      echo "Starting netsay in client mode"
      c=${OPTARG}
      mode="client"
      ;;
    p)
      p=${OPTARG}
      ;;
    s)
      echo "Starting netsay in server mode"
      mode="server"
      ;;
    *)
      echo "Unrecognized argument"
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [[ "${mode}" == "server" ]]; then
  netsay_server
elif [[ "${mode}" == "client" ]]; then
  if [[ -z "${p}" ]]; then
    port="1111"
  else
    port="${p}"
  fi
  netsay_client "${c}" "${port}"
fi
