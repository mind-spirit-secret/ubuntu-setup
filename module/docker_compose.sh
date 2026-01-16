#!/usr/bin/env bash

module_docker_compose(){
	if command -v docker-compose >/dev/null 2>&1; then
		log "INFO" "docker-compose already present."
		return 0
	fi

	if ! ensure_packages docker-compose; then
		log "ERROR" "docker-compose installation failed."
		return 1
	fi

	log "INFO" "docker-compose installed."
}