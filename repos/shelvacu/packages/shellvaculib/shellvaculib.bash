: # adding a nothing line at top so that shellcheck disable doesn't accidentally apply to the whole file.

# the entire point is to be sh-compatible
# shellcheck disable=SC2292
if [ -z "${BASH_VERSINFO-}" ]; then
  echo "shellvaculib.bash: This script only works with bash" >&2
  exit 1
fi

# Test if this file was sourced, see https://stackoverflow.com/a/28776166
if ! (return 0 2>/dev/null); then
  # this file was *not* sourced
  echo "shellvaculib.bash: This file should not be run directly, it should only be sourced" >&2
  exit 1
fi

if [[ ${SHELLVACULIB_COMPAT-0} == 1 ]]; then
  : # nothing
else
  set -euo pipefail
  shopt -s shift_verbose
  shopt -s lastpipe
fi

svl_eprintln() {
  printf '%s' "$@" >&2
  printf '\n' >&2
}

_shellvaculib_debug_enabled() {
  [[ ${SHELLVACULIB_DEBUG-0} == 1 ]]
}

_shellvaculib_debug_print() {
  # shellcheck disable=SC2310
  if _shellvaculib_debug_enabled; then
    svl_eprintln "$@"
  fi
}

# shellcheck disable=SC2310
if _shellvaculib_debug_enabled; then
  svl_eprintln "shellvaculib.bash sourced."
  declare dollar_zero dollar_underscore
  dollar_zero="$0"
  dollar_underscore="$_"
  declare -a dollar_at
  dollar_at=("$@")
  declare -p dollar_zero dollar_underscore dollar_at
  cmd=(
    "declare" "-p"
    HOME
    CDPATH
    PATH
    IFS

    COLUMNS
    LINES

    PWD
    OLDPWD
    DIRSTACK

    UID
    EUID
    GROUPS

    BASH
    BASHOPTS
    BASHPID
    PPID
    BASH_ARGC
    BASH_ARGV
    BASH_ARGV0
    BASH_COMMAND
    BASH_COMPAT
    BASH_EXECUTION_STRING
    BASH_LINENO
    BASH_SOURCE
    BASH_SUBSHELL
    BASH_VERSINFO
    BASH_VERSION
    BASH_XTRACEFD
    CHILD_MAX
    COPROC
    EPOCHREALTIME
    EXECIGNORE
    FIGNORE
    FUNCNAME
    FUNCNEST
    GLOBIGNORE
    histchars
    HISTCMD
    HISTCONTROL
    HISTFILE
    HISTFILESIZE
    HISTIGNORE
    HISTSIZE
    HISTTIMEFORMAT
    HOSTFILE
    HOSTNAME
    HOSTTYPE
    INPUTRC
    LANG
    LC_ALL
    LC_COLLATE
    LC_CTYPE
    LC_MESSAGES
    LC_NUMERIC
    LC_TIME
    LINENO
    MACHTYPE
    MAILCHECK
    OPTERR
    PIPESTATUS
    POSIXLY_CORRECT
    PROMPT_COMMAND
    PROMPT_DIRTRIM
    PS0
    PS1
    PS2
    PS3
    PS4
    SECONDS
    SHELL
    SHELLOPTS
    SHLVL
    TIMEFORMAT
    TMPDIR
  )
  "${cmd[@]}" || true
fi

declare -a _shellvaculib_script_args
declare _shellvaculib_arg0 _shellvaculib_arg0_canonicalized _shellvaculib_initialized

if [[ ${_shellvaculib_initialized-} != 1 ]]; then
  _shellvaculib_arg0="$0"
  _shellvaculib_script_args=("$@")
  if ! _shellvaculib_arg0_canonicalized="$(realpath -- "$0")"; then
    svl_eprintln "warn: could not get realpath of \$0: $0"
  fi
  _shellvaculib_initialized=1
else
  _shellvaculib_debug_print "warn: shellvaculib re-sourced"
fi

svl_err() {
  if [[ $# == 0 ]]; then
    echo "$0: unspecified error" >&2
  else
    echo "$0:" "$@" >&2
  fi
}

svl_die() {
  svl_err "$@"
  exit 1
}

svl_throw_skip() {
  if [[ $# == 0 ]]; then
    svl_die "svl_throw_skip expects at least one arg"
  fi
  declare -i skip="$1" i
  shift
  declare -a args=("$@")
  #always skip svl_throw_skip itself
  skip=$((skip + 1))
  for ((i = ${#FUNCNAME[@]} - 1; i >= skip; i--)); do
    svl_err "in ${FUNCNAME[i]}[${BASH_LINENO[i - 1]}]:"
  done
  svl_die "${args[@]}"
}

svl_throw() {
  svl_throw_skip 1 "$@"
}

declare -gi _shellvaculib_max_args=1000000

_shellvaculib_min_andor_max_args_impl() {
  declare -i actual_count="$1" minimum_count="$2" maximum_count="$3"
  if ((minimum_count <= actual_count)) && ((actual_count <= maximum_count)); then
    return 0
  fi
  if ((actual_count < 0)) || ((minimum_count < 0)) || ((maximum_count < 0)); then
    svl_die "this shouldn't happen (one of the counts negative in ${FUNCNAME[0]})"
  fi
  local expect_message
  if ((minimum_count == maximum_count)); then
    expect_message="expected exactly $minimum_count argument(s)"
  elif ((minimum_count == 0)) && ((maximum_count != _shellvaculib_max_args)); then
    expect_message="expected at most $maximum_count argument(s)"
  elif ((minimum_count != 0)) && ((maximum_count == _shellvaculib_max_args)); then
    expect_message="expected at least $minimum_count argument(s)"
  elif ((minimum_count != 0)) && ((maximum_count != _shellvaculib_max_args)); then
    expect_message="expected between $minimum_count and $maximum_count arguments"
  else
    svl_die "this shouldnt be possible really"
  fi
  local error_message="Wrong number of arguments, $expect_message, got $actual_count"
  if [[ ${#FUNCNAME[@]} == 1 ]]; then
    #we are being called from the top-level
    svl_die "$error_message"
  else
    svl_throw_skip 2 "$error_message"
  fi
}

svl_minmax_args() {
  if [[ $# != 3 ]]; then
    svl_throw_skip 1 "expected 3 args to svl_minmax_args, got $#"
  fi
  _shellvaculib_min_andor_max_args_impl "$1" "$2" "$3"
}

svl_min_args() {
  if [[ $# != 2 ]]; then
    svl_throw_skip 1 "expected 2 args to svl_min_args, got $#"
  fi
  _shellvaculib_min_andor_max_args_impl "$1" "$2" "$_shellvaculib_max_args"
}

svl_max_args() {
  if [[ $# != 2 ]]; then
    svl_throw_skip 1 "expected 2 args to svl_max_args, got $#"
  fi
  _shellvaculib_min_andor_max_args_impl "$1" 0 "$2"
}

svl_exact_args() {
  if [[ $# != 2 ]]; then
    svl_throw_skip 1 "expected 2 args to svl_exact_args, got $#"
  fi
  _shellvaculib_min_andor_max_args_impl "$1" "$2" "$2"
}

svl_idempotent_add_prompt_command() {
  svl_exact_args $# 1
  PROMPT_COMMAND[0]=''${PROMPT_COMMAND[0]:-}
  declare to_add="$1" cmd
  for cmd in "${PROMPT_COMMAND[@]}"; do
    if [[ $to_add == "$cmd" ]]; then
      return 0
    fi
  done
  PROMPT_COMMAND+=("$to_add")
  return 0
}

# because the folder containing the script as well as PWD can be deleted while we're using it (or its parents), it's impossible to know for sure. Woohoo!
svl_probably_in_script_dir() {
  declare script_dir canon_pwd
  if [[ -z $_shellvaculib_arg0_canonicalized ]]; then
    _shellvaculib_debug_print "svl_probably_in_script_dir called when _shellvaculib_arg0_canonicalized is unset or blank, always returning false"
    return 1
  fi
  if ! script_dir="$(dirname -- "$_shellvaculib_arg0_canonicalized")"; then
    # shellcheck disable=SC2016  # this is intentionally not expanding
    _shellvaculib_debug_print 'svl_probably_in_script_dir failed to call $(dirname -- $_shellvaculib_arg0_canonicalized), returning 1'
    return 1
  fi
  if ! canon_pwd="$(realpath -- "$PWD")"; then
    # shellcheck disable=SC2016  # this is intentionally not expanding
    _shellvaculib_debug_print 'svl_probably_in_script_dir failed to call $(realpath -- $PWD), returning 1'
    return 1
  fi
  [[ $script_dir == "$canon_pwd" ]]
}

svl_assert_probably_in_script_dir() {
  # shellcheck disable=SC2310
  if ! svl_probably_in_script_dir; then
    svl_die "This script must be run in its directory"
  fi
  return 0
}

svl_assert_root() {
  if [[ -z ${EUID:-} ]]; then
    svl_throw 'EUID unset!?'
  fi
  if [[ $EUID != 0 ]]; then
    svl_die "must be root to run this"
  fi
  return 0
}

svl_auto_sudo() {
  if [[ -z ${EUID:-} ]]; then
    svl_throw 'EUID unset!?'
  fi
  if [[ $EUID == 0 ]]; then
    return 0
  fi
  if [[ ${SHELLVACULIB_IN_AUTO_SUDO:-} == 1 ]]; then
    svl_throw 'svl_auto_sudo: already inside auto-sudo and failed :('
  fi
  declare sudo_path
  sudo_path="$(command -v sudo)"
  exec "$sudo_path" SHELLVACULIB_IN_AUTO_SUDO=1 -- "$_shellvaculib_arg0" "${_shellvaculib_script_args[@]}"
}

# svl_in_array {needle} {*haystack...}
# false (return code 1) when haystack is empty
svl_in_array() {
  svl_min_args $# 1
  declare needle="$1" value
  shift 1

  for value; do
    if [[ $value == "$needle" ]]; then
      return 0
    fi
  done
  return 1
}

# svl_ask
# svl_ask "Are you sure you want to rotate the transcordial syncophactor?"
#   --result-var [name] required
#   --default-yes
#   --default-no
#   --long-yes
#   --short-yes
#
# Use like:
#
# declare question_response
# svl_ask --result-var question_response "Are you sure you want to do that?"
# if [[ $question_response == true ]]; then
#   # ...
# fi
svl_ask() {
  declare default_yes=false short_yes=null
  declare result_var_name
  declare -a non_option_args=()
  while (($# > 0)); do
    declare arg="$1"
    shift
    case "$arg" in
    -y | --default-yes)
      default_yes=true
      ;;
    --default-no)
      default_yes=false
      ;;
    --short-yes)
      short_yes=true
      ;;
    --long-yes)
      short_yes=false
      ;;
    --result-var)
      if (($# == 0)); then
        svl_throw "no arg passed to --result-var in svl_ask"
      fi
      result_var_name="$1"
      shift
      ;;
    --)
      non_option_args+=("$@")
      shift $#
      break
      ;;
    -*)
      svl_throw "invalid option \`$arg' for svl_ask"
      ;;
    *)
      non_option_args+=("$arg")
      ;;
    esac
  done

  if [[ $# != 0 ]]; then
    svl_throw "bug in arg parsing, no args should be left but there are $# left"
  fi

  if [[ ${result_var_name:-x} == x ]]; then
    svl_throw "must set --result-var in svl_ask"
  fi
  declare -n result_ref="$result_var_name"

  if [[ $short_yes == null ]]; then
    short_yes=$default_yes
  fi

  svl_max_args ${#non_option_args[@]} 1
  declare prompt
  if [[ ${#non_option_args[@]} == 0 ]]; then
    prompt="Are you sure you want to continue?"
  else
    prompt="${non_option_args[0]}"
  fi
  declare yes_prompt
  if [[ $short_yes == true ]]; then
    yes_prompt="y"
  else
    yes_prompt="yes"
  fi
  declare no_prompt="n"
  if [[ $default_yes == true ]]; then
    svl_capitalize_var yes_prompt
  else
    svl_capitalize_var no_prompt
  fi
  declare full_prompt
  full_prompt="$prompt [${yes_prompt}/${no_prompt}]: "

  declare -a yes_responses=("yes")
  declare -a no_responses=("no" "n")
  if [[ $short_yes == true ]]; then
    yes_responses+=("y")
  fi
  if [[ $default_yes == true ]]; then
    yes_responses+=("")
  else
    no_responses+=("")
  fi

  declare result
  while true; do
    declare response
    read -r -p "$full_prompt" response || true
    svl_trim_var response
    svl_downcase_var response
    if svl_in_array "$response" "${yes_responses[@]}"; then
      result=true
      break
    fi
    if svl_in_array "$response" "${no_responses[@]}"; then
      result=false
      break
    fi
    printf "Unrecognized response %q\n" "$response"
  done
  # shellcheck disable=SC2034   #indirection
  result_ref=$result
}

# svl_confirm_or_die
# svl_confirm_or_die -- "Are you sure you want to rotate the transcordial syncophactor?"
#   accepts same args as svl_ask, except don't pass --result-var
svl_confirm_or_die() {
  declare arg
  for arg; do
    case "$arg" in
    --result-var)
      svl_throw "--result-var not allowed in svl_confirm_or_die"
      ;;
    --)
      break
      ;;
    esac
  done
  declare question_result
  svl_ask --result-var question_result "$@"
  if [[ $question_result == true ]]; then
    return 0
  else
    svl_die "exiting"
  fi
}

# svl_count #=> 0
# svl_count a b c #=> 3
# prints the number of arguments on stdout.
svl_count() {
  echo $#
  return 0
}

# svl_count_matches 'foo*bar'
# counts the number of matches (correctly, even if nullglob is not set) and print to stdout
svl_count_matches() {
  svl_exact_args $# 1
  declare nullglob_before
  if shopt -q nullglob; then
    nullglob_before=enabled
  else
    nullglob_before=disabled
  fi
  shopt -s nullglob
  # intentional expansion of arg, so that *s and such will expand
  # shellcheck disable=SC2086
  svl_count $1
  if [[ $nullglob_before == "disabled" ]]; then
    shopt -u nullglob
  fi
  return 0
}

svl_trim_var() {
  svl_exact_args $# 1
  declare -n var_ref="$1"
  # remove leading whitespace characters
  var_ref="${var_ref#"${var_ref%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var_ref="${var_ref%"${var_ref##*[![:space:]]}"}"
}

svl_downcase_var() {
  svl_exact_args $# 1
  declare -n var_ref="$1"
  var_ref="${var_ref,,}"
}

svl_upcase_var() {
  svl_exact_args $# 1
  declare -n var_ref="$1"
  var_ref="${var_ref^^}"
}

svl_capitalize_var() {
  svl_exact_args $# 1
  declare -n var_ref="$1"
  var_ref="${var_ref^}"
}

# svl_trim "  foo \n"
#   prints to stdout: "foo"
svl_trim() {
  svl_exact_args $# 1
  declare var="$1"
  svl_trim_var var
  printf '%s' "$var"
}

# svl_capture_exit_code_into var_name cmd args args args
svl_capture_exit_code_into() {
  svl_min_args $# 2
  declare -n var_ref="$1"
  shift
  if "$@"; then
    var_ref=$?
  else
    var_ref=$?
  fi
  return 0
}
