declare -A ABBR_MAP # Initialize an associative array called ABBR_MAP

abbr() {
  local arg1="${1[(ws:=:)1]}" # Split the first argument around the first = sign
  local arg2="${1[(ws:=:)2]}" # to mimic the syntax of alias/abbr
  
  alias "$arg1=" #This is done for syntax highlighting only
  
  ABBR_MAP[$arg1]="$arg2"
}

_expand() {
  local currentWord="${LBUFFER/* /}${RBUFFER/ */}"
  local potentialAbbr="${ABBR_MAP[$currentWord]}"
  
  if [[ -z "$potentialAbbr" ]] ; then # If potentialAbbr is an empty string
    return 0 # Nothing to expand
  else  # If there is something to expand
    zle backward-kill-word # Delete the word that's going to be replaced
    
    LBUFFER+="${potentialAbbr[(ws:^:)1]}" # Append the first potentialAbbr ^ chunk to LBUFFER
    
    if [[ "${potentialAbbr[(ws:^:)2]}" == "$potentialAbbr" ]] ; then # If there isn't second ^ chunk
      LBUFFER+=" "
      return 1 # Simple expand
    else
      RBUFFER="${potentialAbbr[(ws:^:)2]}$RBUFFER" # Prepend the second part to RBUFFER
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
  else
    if [[ "$expandReturnCode" == 1 ]] ; then # If simple expand
      zle accept-line
    fi
  fi
}

zle -N _spaceExpand
zle -N _enterExpand

bindkey " " _spaceExpand
bindkey "^M" _enterExpand
