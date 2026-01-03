#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  local level=$1
  shift
  printf '[%s] %s\n' "${level}" "$*"
}

fail() {
  log "ERROR" "$*"
  exit 1
}

SUDO="sudo"
if [[ ${EUID:-0} -eq 0 ]]; then
  SUDO=""
fi

APT_UPDATED=0
apt_update_once() {
  if [[ ${APT_UPDATED} -ne 0 ]]; then
    return
  fi
  log "INFO" "Refreshing apt cache."
  ${SUDO} apt-get update
  APT_UPDATED=1
}

ensure_packages() {
  local packages=("$@")
  if [[ ${#packages[@]} -eq 0 ]]; then
    return
  fi
  apt_update_once
  log "INFO" "Installing packages: ${packages[*]}"
  ${SUDO} apt-get install -y "${packages[@]}"
}

load_modules() {
  local module_dir="${SCRIPT_DIR}/module"
  local modules=()
  mapfile -t modules < <(find "${module_dir}" -maxdepth 1 -type f -name '*.sh' -printf '%f\n' | sort)
  if [[ ${#modules[@]} -eq 0 ]]; then
    fail "No modules found in ${module_dir}"
  fi
  for module_file in "${modules[@]}"; do
    # shellcheck source=/dev/null
    source "${module_dir}/${module_file}"
  done
}

# run_modules() {
#   module_git
#   module_micro
#   module_docker_compose
# }

main() {
  load_modules
  run_modules
  log "INFO" "Setup complete."
}

main "$@"
