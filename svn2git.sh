#!/usr/bin/env bash

WORKING_DIR="$(pwd)"

hash svn 2> /dev/null

if [ "${?}" -ne 0 ]; then
  echo "svn2git: svn command not found."

  exit 1
fi

git svn --version 2> /dev/null

if [ "${?}" -ne 0 ]; then
  echo "svn2git: git svn command not found."

  exit 1
fi

help() {
  cat << EOF
svn2git: Usage: svn2git [SOURCE] <DESTINATION>
EOF

  exit 1
}

if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  help
fi

unknown_command() {
  echo "svn2git: Unknown command. See 'svn2git --help'"

  exit 1
}

if [ "${#}" -ne 0 ]; then
  ARGUMENTS=()

  USERNAME=""
  PASSWORD=""

  while [ "${1}" != "" ]; do
    ARGUMENT="${1}"

    shift

    case "${ARGUMENT}" in
      "-u"|"--username")
        USERNAME="${1}";

        shift
        ;;
      "-p"|"--password")
        PASSWORD="${1}";

        shift
        ;;
      *)
        ARGUMENTS+=("${ARGUMENT}")
        ;;
    esac
  done

  set "${ARGUMENTS[@]}"
fi

OPTIONS=""

if [ -n "${USERNAME}" ] && [ -n "${PASSWORD}" ]; then
  OPTIONS="--username ${USERNAME} --password ${PASSWORD} --no-auth-cache"
fi

if [ "${#}" -lt 1 ] || [ "${#}" -gt 2 ]; then
  unknown_command
fi

DESTINATION="${2}"

if [ "${#}" -lt 2 ]; then
  DESTINATION="${1}"
fi

if [ -d "${DESTINATION}" ]; then
  echo "svn2git: Destination directory already exists: ${DESTINATION}"

  exit 1
fi

mkdir -p "${DESTINATION}"

cd "${DESTINATION}"

DESTINATION="$(pwd)"

SOURCE="${WORKING_DIR}"

if [ "${#}" -gt 1 ]; then
  SOURCE="${1}"
fi

SOURCE="$(svn ${OPTIONS} --trust-server-cert --non-interactive info ${SOURCE} 2> /dev/null | grep ^URL: | awk '{ print $2 }')"

if [ -z "${SOURCE}" ]; then
  echo "svn2git: Invalid repository."

  exit 1
fi

git svn clone "${SOURCE}" "${DESTINATION}"

cd "${WORKING_DIR}"
