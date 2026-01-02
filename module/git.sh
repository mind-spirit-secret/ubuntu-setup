#!/usr/bin/env bash
module_git(){ if command -v git >/dev/null 2>&1; then log "INFO" "git already present."; else ensure_packages git; log "INFO" "git installed."; fi; }
