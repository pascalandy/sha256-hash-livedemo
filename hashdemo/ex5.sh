#!/usr/bin/env bash

# A best practices Bash script template with many useful functions. This file
# sources in the bulk of the functions from the source.sh file which it expects
# to be in the same directory. Only those functions which are likely to need
# modification are present in this file. This is a great combination if you're
# writing several scripts! By pulling in the common functions you'll minimise
# code duplication, as well as ease any potential updates to shared functions.

# A better class of script
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

# DESC: Usage help
# ARGS: None
# OUTS: None
function script_usage() {
    cat << EOF
Usage:
     -h|--help                  Displays this help
     -v|--verbose               Displays verbose output
    -nc|--no-colour             Disables colour output
    -cr|--cron                  Run silently unless we encounter an error
EOF
}

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parse_params() {
    local param
    while [[ $# -gt 0 ]]; do
        param="$1"
        shift
        case $param in
            -h|--help)
                script_usage
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                ;;
            -nc|--no-colour)
                no_colour=true
                ;;
            -cr|--cron)
                cron=true
                ;;
            *)
        esac
    done
}


# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    # load config and variables for this project
    source "$(dirname "${BASH_SOURCE[0]}")/config_and_vars.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/shellcheck.sh"

    trap script_trap_err ERR
    trap script_trap_exit EXIT

    script_init "$@"
    parse_params "$@"
    cron_init
    colour_init
    #lock_init system

    clear; echo;
    goto_myscript;
    echo;
}

# --- Custom script to EDIT HERE
function goto_myscript() {

BLOCK_TRANSACTION=$(echo -n \
"PREVIOUS BLOCK HASH     6ba0e3732c71b04a66a739a20f6a4bdbaa8588c6d34d0be0e1bdb2de0c46c376
FROM                    16cou7Ht6WjTzuFyDBnht9hmvXytg6XdVT
Total Input             33,998.00079631 BTC
Total Output            33,997.98534631 BTC
TO:                     1JYgjo2xnqnEp3ChWGv3rdWDWsJXYcESDD (0.00001 BTC - Output)
DATE:                   2018-03-07_22h26
Size                    2054 (bytes)
Weight                  8216
Received Time           2017-11-12 06:13:15
Block:                  494060
Confirmations           18459 Confirmations
Fees                    0.01545 BTC
Fee per byte            752.191 sat/B")

echo "$BLOCK_TRANSACTION"; echo;

# hash for this transaction is:
HASH_BLOCK=$(printf "$BLOCK_TRANSACTION" | sha256sum);
echo "$HASH_BLOCK"; echo;

MIN="1234"
MAX="1236"

for NONCE in $(seq $MIN $MAX); do

    # hash for with the nouceis:
    HASH_WITH_NOUCE=$(printf "$HASH_BLOCK $NONCE" | sha256sum);

    echo "Hash transaction is:";
    echo "$HASH_BLOCK";
    echo "Using the nouce $NONCE, the aggregated HASH using the nouce is:";
    echo "$HASH_WITH_NOUCE";
    echo;

done;

}

# --- Entrypoint
main "$@"
