declare -A ABBR_MAP # Initialize associative array ABBR_MAP

abbr() {
  alias "$1"="$1" # Allows abbrs to replace built-in commands. Also provides syntax highlighting
  ABBR_MAP[$1]="$2"
}

_expand() {
  local potentialAbbr="${ABBR_MAP[$LBUFFER]}"
  
  if [[ -z "$potentialAbbr" ]] ; then # If potentialAbbr is an empty string i.e not an abbr
    return 0 # Nothing to expand
  else  # If potentialAbbr is an abbr
    local firstCaretSplitPart="${potentialAbbr[(ws:^:)1]}"
    local secondCaretSplitPart="${potentialAbbr[(ws:^:)2]}"
    
    LBUFFER="$firstCaretSplitPart"
    
    if [[ "$secondCaretSplitPart" == "$potentialAbbr" ]] ; then # If no second caret part.
      LBUFFER+=" "
      return 1 # Simple expand
    else
      if [[ -z "$secondCaretSplitPart" ]] ; then # If second part is an empty string 
        return 2 # Caret-at-end expand
      else
        RBUFFER="$secondCaretSplitPart$RBUFFER" # Prepend to RBUFFER
        return 3 # Caret expand
      fi
    fi
  fi
}

_spaceExpand() {
  _expand
  local expandReturnCode="$?"
  
  if [[ "$expandReturnCode" -eq 0 ]] ; then # If expand failed
    zle self-insert # Insert space character at cursor position
    
    ((CURSOR--)) # Move cursor 1 space to the left
    _expand # Try expanding again
    local expandReturnCode="$?"
    
    if [[ "$expandReturnCode" -eq 0 ]] ; then # If second expand failed
      ((CURSOR++))
    elif [[ "$expandReturnCode" -le 2 ]] ; then # If simple/caret-at-end expand
      LBUFFER=${LBUFFER%" "} # Remove a space from the end of LBUFFER
    else # If caret expand
      ((CURSOR--))
    fi
  fi
}

_enterExpand() {
  _expand
  local expandReturnCode="$?"
  
  if [[ "$expandReturnCode" -le 1 ]] ; then # If expand had no caret
    zle accept-line
  fi
}

zle -N _spaceExpand
zle -N _enterExpand

bindkey " " _spaceExpand
bindkey "^M" _enterExpand