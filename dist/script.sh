#!/usr/bin/env bash
set -euo pipefail

abort() {
  printf '%s\n' "$@" >&2
  exit 1
}

value_enabled() {
  case "${1:-}" in
    '' | 0 | false | FALSE | False | no | NO | No | off | OFF | Off)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

if [ -z "${BASH_VERSION:-}" ]; then
  abort 'Bash is required to interpret this script.'
fi

if [[ -n "${POSIXLY_CORRECT+1}" ]]; then
  abort 'Bash must not run in POSIX mode. Please unset POSIXLY_CORRECT and try again.'
fi

if { [[ -t 1 ]] || value_enabled "${FORCE_COLOR:-}"; } && [[ -z "${NO_COLOR-}" ]]; then
  tty_escape() { printf '\033[%sm' "$1"; }
else
  tty_escape() { :; }
fi

tty_mkbold() { tty_escape "1;$1"; }
tty_mkdim() { tty_escape "2;$1"; }
tty_bold="$(tty_mkbold 39)"
tty_dim="$(tty_mkdim 39)"
tty_red="$(tty_mkbold 31)"
tty_reset="$(tty_escape 0)"
tty_tp="$(tty_escape '38;2;0;200;138')"
tty_ts="$(tty_escape '38;2;219;39;119')"

CLI_NAME="${0##*/}"
# Keep a single top-level assignment so release automation can stamp the entrypoint in place.
SCRIPT_VERSION="v1.0.0-beta.1"

DEBUG="${DEBUG:-${RUNNER_DEBUG:-}}"

chomp() {
  printf '%s' "${1/"$'\n'"/}"
}

debug_enabled() {
  value_enabled "${DEBUG:-}"
}

shell_join() {
  local arg

  printf '%s' "${1:-}"
  if [[ $# -eq 0 ]]; then
    return 0
  fi

  shift

  for arg in "$@"; do
    printf ' '
    printf '%s' "${arg// /\ }"
  done
}

debug_log() {
  if value_enabled "${DEBUG:-}"; then
    printf '%sdebug%s %s\n' "${tty_dim}" "${tty_reset}" "$(shell_join "$@")" >&2
  fi
}

note() {
  printf '%snote%s: %s\n' "${tty_ts}" "${tty_reset}" "$(chomp "$(shell_join "$@")")"
}

fail() {
  local message="$1"
  local exit_code="${2:-1}"

  printf '%serror%s: %s\n' "${tty_red}" "${tty_reset}" "$(chomp "${message}")" >&2
  exit "${exit_code}"
}

usage() {
  local debug_display="off"

  if debug_enabled; then
    debug_display="on"
  fi

  cat <<EOF
Usage: ${tty_bold}${CLI_NAME}${tty_reset} ${tty_dim}[options] [arguments...]${tty_reset}

${tty_tp}Options:${tty_reset}
  --debug     enable debug logging ${tty_dim}[default: ${debug_display}]${tty_reset}
  --version   print the script version ${tty_dim}[default: ${SCRIPT_VERSION}]${tty_reset}
  -h, --help  show this help message

This starter intentionally has no product logic yet.
Additional arguments are ignored by the starter until you replace the placeholder logic.
Replace the body of ${CLI_NAME} with your project behavior.
EOF
}

show_version() {
  printf '%s\n' "${SCRIPT_VERSION}"
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --debug)
        DEBUG="1"
        shift
        ;;
      --version)
        show_version
        return 0
        ;;
      -h | --help)
        usage
        return 0
        ;;
      --)
        shift
        break
        ;;
      -*)
        fail "Unrecognized option ${tty_bold}$1${tty_reset}. Run ${tty_ts}${CLI_NAME} --help${tty_reset} for usage."
        ;;
      *)
        break
        ;;
    esac
  done

  if [[ $# -gt 0 ]]; then
    debug_log 'ignoring starter positional arguments:' "$@"
  fi

  debug_log 'running placeholder command body'
  note "Replace the body of ${CLI_NAME} with your project logic."
}

main "$@"
