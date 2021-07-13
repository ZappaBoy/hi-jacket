#!/bin/bash
set -euo pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1 ; pwd -P )"
TESTING_ENVIRONMENT_PATH="${SCRIPT_PATH}/testing-environment"

cd "${TESTING_ENVIRONMENT_PATH}" && docker-compose up --build -d

python "${SCRIPT_PATH}/dispatcher.py"

cd "${TESTING_ENVIRONMENT_PATH}" && docker-compose down -v
