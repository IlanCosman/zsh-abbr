declare -A expandableMap # Initialize an associative array called expandableMap

abbr() {
  local arg1=${1[(ws:=:)1]} # Split the first argument around the first = sign
  local arg2=${1[(ws:=:)2]} # to mimic the traditional syntax of alias/abbr
  
  alias "$arg1=" #This is done for syntax highlighting only
  
  expandableMap[$arg1]="$arg2"
}

_expand() {
  local currentWord="${LBUFFER/* /}${RBUFFER/ */}"
  local expandable=${expandableMap[$currentWord]}
  
  if [[ -z "$expandable" ]] ; then # If expandable is an empty string
    return 1 # Nothing to expand
  else  # If there is something to expand
    zle backward-kill-word # Delete the word that's going to be replaced
    
    LBUFFER+=${expandable[(ws:^:)1]} # Append the first expandable ^ chunk to LBUFFER
    
    if [[ "${expandable[(ws:^:)2]}" != "$expandable" ]] ; then # If there is actually a second ^ chunk
      RBUFFER=${expandable[(ws:^:)2]}$RBUFFER # Prepend the second part to RBUFFER
    else
      LBUFFER+=" "
    fi
    
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
