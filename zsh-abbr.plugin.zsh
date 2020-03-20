declare -A ABBR_MAP # Initialize associative array ABBR_MAP

abbr() {
  local arg1="${1[(ws:=:)1]}" # Split first argument around = sign
  local arg2="${1[(ws:=:)2]}" # to mimic the syntax of alias/abbr
  
  alias "$arg1=" # For syntax highlighting only
  
  ABBR_MAP[$arg1]="$arg2"
}

_expand() {
  local currentWord="${LBUFFER/* /}${RBUFFER/ */}"
  local potentialAbbr="${ABBR_MAP[$currentWord]}"
  
  if [[ -z "$potentialAbbr" ]] ; then # If potentialAbbr is an empty string, i.e not an abbr
    return 0 # Nothing to expand
  else  # If potentialAbbr is actually an abbr
    zle backward-kill-word # Delete word before cursor
    zle kill-word # and after cursor so that it can be replaced
    
    LBUFFER+="${potentialAbbr[(ws:^:)1]}" # Append first potentialAbbr ^ chunk to LBUFFER
    
    if [[ "${potentialAbbr[(ws:^:)2]}" == "$potentialAbbr" ]] ; then # If no second ^ chunk
      LBUFFER+=" "
      return 1 # Simple expand
    else
      RBUFFER="${potentialAbbr[(ws:^:)2]}$RBUFFER" # Prepend second part to RBUFFER
      return 2 # Caret expand
    fi
  fi
}

_spaceExpand() {
  _expand
  local expandReturnCode="$?"
  
  if [[ "$expandReturnCode" == 0 ]] ; then # If expand failed
    zle self-insert
  fi
}

_enterExpand() {
  _expand
  local expandReturnCode="$?"
  
  if [[ "$expandReturnCode" == 0 ]] ; then # If expand failed
    zle accept-line
    
    elif [[ "$expandReturnCode" == 1 ]] ; then # If simple expand
    zle accept-line
  fi
}

zle -N _spaceExpand
zle -N _enterExpand

bindkey " " _spaceExpand
bindkey "^M" _enterExpand