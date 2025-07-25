#!/bin/bash
# ui/helpers.sh - Common helper functions for SetUpMyPi scripts

# Default log file location
LOG_FILE="${LOG_FILE:-logs/sump.log}"

# Log a message with timestamp
log_msg() {
  local msg="$1"
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "$(date +'%F %T') - $msg" | tee -a "$LOG_FILE"
}

# Prompt the user for confirmation. Return 0 for yes, 1 for no.
confirm_prompt() {
  local prompt="$1"
  if [[ $INTERFACE_MODE == "dialog" ]] && command -v dialog &>/dev/null; then
    dialog --clear --stdout --yesno "$prompt" 7 60
    return $?
  else
    local resp
    read -rp "$prompt [O/n] " resp
    [[ "$resp" =~ ^([OoYy]|)$ ]]
    return $?
  fi
}
