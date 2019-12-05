#!/usr/bin/env bash

# A best practices Bash script template with many useful functions. This file
# sources in the bulk of the functions from the source.sh file which it expects
# to be in the same directory. Only those functions which are likely to need
# modification are present in this file. This is a great combination if you're
# writing several scripts! By pulling in the common functions you'll minimise
# code duplication, as well as ease any potential updates to shared functions.

# A better class of script
set -o errexit  # Exit on most errors (see the manual)
set -o errtrace # Make sure any error trap is inherited
set -o nounset  # Disallow expansion of unset variables
set -o pipefail # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

# DESC: Usage help
# ARGS: None
# OUTS: None
function script_usage() {
	cat <<EOF
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
		-h | --help)
			script_usage
			exit 0
			;;
		-v | --verbose)
			verbose=true
			;;
		-nc | --no-colour)
			no_colour=true
			;;
		-cr | --cron)
			cron=true
			;;
		*) ;;
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

	clear
	echo
	goto_myscript
	echo
}

# --- Custom script to EDIT HERE
function goto_myscript() {

	BLOCK_TRANSACTION="C'est le zoo a Saint-Tite-des-Caps."

	echo "$BLOCK_TRANSACTION"
	echo

	# hash for this transaction is:
	HASH_BLOCK=$(printf "$BLOCK_TRANSACTION" | sha256sum)
	echo "$HASH_BLOCK"

  ########################################################
  echo;echo;

	BLOCK_TRANSACTION="C'est le zoo à Saint-Tite-des-Caps."

	echo "$BLOCK_TRANSACTION"
	echo

	# hash for this transaction is:
	HASH_BLOCK=$(printf "$BLOCK_TRANSACTION" | sha256sum)
	echo "$HASH_BLOCK"
}

# --- Entrypoint
main "$@"
