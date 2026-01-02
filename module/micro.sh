#!/usr/bin/env bash
module_micro(){ if command -v micro >/dev/null 2>&1; then log "INFO" "micro already present."; else ensure_packages micro; log "INFO" "micro installed."; fi; }
