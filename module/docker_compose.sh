#!/usr/bin/env bash
module_docker_compose(){ if command -v docker-compose >/dev/null 2>&1; then log "INFO" "docker-compose already present."; else ensure_packages docker-compose; log "INFO" "docker-compose installed via apt."; fi; }
