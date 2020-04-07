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
      return 1 # Simple expand
    else
      RBUFFER="$secondCaretSplitPart$RBUFFER" # Prepend to RBUFFER
      return 2 # Caret expand
    fi
  fi
}

_spaceExpand() {
  _expand
  local expandExitStatus="$?"
  
  if [[ "$expandExitStatus" -le 1 ]] ; then # If not caret expand
    zle self-insert # Insert space character at cursor position
  fi
}

_enterExpand() {
  _expand
  local expandExitStatus="$?"
  
  if [[ "$expandExitStatus" -le 1 ]] ; then
    zle accept-line
  fi
}

zle -N _spaceExpand
zle -N _enterExpand

bindkey " " _spaceExpand
bindkey "^M" _enterExpand
