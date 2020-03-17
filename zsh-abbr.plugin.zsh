declare -A expandableMap # Initialize an associative array called expandableMap

abbr() {
  local arg1=${1[(ws:=:)1]}
  local arg2=${1[(ws:=:)2]}
  
  expandableMap[$arg1]="$arg2 ^"
}

_expand() {
  local expandable=${expandableMap[$LBUFFER]}
  
  if [[ -z "$expandable" ]] ; then # If expandable is an empty string
    return 1 # Nothing to expand
  else  # If there is something to expand
    LBUFFER=${expandable[(ws:^:)1]} # Then split expandable around the first ^
    RBUFFER=${expandable[(ws:^:)2]} # and set the R/L buffers equal to the two parts
    return 0 # Succesfully expanded
  fi
}

_spaceExpand() {
  _expand || zle self-insert # If expand fails, insert a space
}

_enterExpand() {
  _expand && if [[ -z "$RBUFFER" ]] ; then zle accept-line ; fi || zle accept-line 
  # If succesfully expanded, if RBUFFER is empty then accept the line. If expand failed then accept the line.
}

zle -N _spaceExpand
zle -N _enterExpand

bindkey " " _spaceExpand
bindkey "^M" _enterExpand
