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
  
  if [[ -z "$potentialAbbr" ]] ; then # If potentialAbbr is an empty string i.e not an abbr
    return 0 # Nothing to expand
  else  # If potentialAbbr is an abbr
    zle kill-word && zle backward-kill-word # Delete the whole currentWord so that it can be replaced
    
    LBUFFER+="${potentialAbbr[(ws:^:)1]}" # Append first potentialAbbr ^ chunk to LBUFFER
    
    if [[ "${potentialAbbr[(ws:^:)2]}" == "$potentialAbbr" ]] ; then # If no second ^ chunk
      LBUFFER+=" "
      return 1 # Simple expand
    else
      if [[ -n "${potentialAbbr[(ws:^:)2]}" ]] ; then # If second chunk is not empty string
        RBUFFER="${potentialAbbr[(ws:^:)2]}$RBUFFER" # Prepend second part to RBUFFER
        return 2 # Caret expand
      else
        return 3 # Caret at end expand
      fi
    fi
  fi
}

_spaceExpand() {
  _expand
  local expandReturnCode="$?"
  
  if [[ "$expandReturnCode" == 0 ]] ; then # If expand failed
    zle self-insert # Insert space character at cursor position
    
    ((CURSOR-=2)) # Move cursor 2 spaces to the left
    _expand # Try expanding again
    expandReturnCode="$?"
    
    if [[ "$expandReturnCode" == 0 ]] ; then # If expand failed
      ((CURSOR++))
    elif [[ "$expandReturnCode" == 1 ]] ; then # If simple expand
      LBUFFER=${LBUFFER%" "} # Remove a space from the end of LBUFFER
    elif [[ "$expandReturnCode" == 2 ]] ; then # If caret expand
      ((CURSOR--))
    elif [[ "$expandReturnCode" == 3 ]] ; then # If caret at end expand
      LBUFFER=${LBUFFER%" "}
    fi
    
    ((CURSOR++))
  fi
}

_enterExpand() {
  _expand
  local expandReturnCode="$?"
  
  if [[ "$expandReturnCode" != "2" ]] && [[ "$expandReturnCode" != "3" ]] ; then # If expand has no caret
    zle accept-line
  fi
}

zle -N _spaceExpand
zle -N _enterExpand

bindkey " " _spaceExpand
bindkey "^M" _enterExpand