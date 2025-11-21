#!/bin/bash
set -euo pipefail

# Source logging library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../lib/log.sh"

# This script lists critical pos services.
# Usage: ./script.sh [input_file]
# If no input_file is provided, it defaults to "op-succinct.txt".

# Validate config file
default_input_file="${SCRIPT_DIR}/op-succinct.txt"
input_file=${1:-"${default_input_file}"}
if [[ ! -f "${input_file}" ]]; then
  echo "No input file found"
  exit 1
fi
log_info "Using input file '${input_file}'"

# Exclude non-critical services
exclude_l1_services=("lighthouse-geth" "geth-lighthouse" "validator-key-generation")
exclude_additional_services=("bridge-spammer" "test-runner" "tx-spammer")
exclude_monitoring_services=("grafana" "panoptichain" "prometheus")
exclude_patterns=("${exclude_l1_services[@]}" "${exclude_additional_services[@]}" "${exclude_monitoring_services[@]}")
exclude_regex=$(IFS='|'; echo "${exclude_patterns[*]}")
log_debug "Excluding services matching regex: ${exclude_regex}"

# List critical services
services=$(grep -E "(RUNNING|STOPPED)" "${input_file}" | grep -v "Status" | grep -Ev "${exclude_regex}" | awk '{print $2}' | jq -R -s 'split("\n") | map(select(. != ""))' || true)
if [[ -z "$services" || "$services" == "[]" ]]; then
  log_info "No services found"
  echo "[]"
  exit 0
fi
services_count=$(echo "$services" | jq 'length')
log_info "Found ${services_count} critical services"
echo "${services}"
