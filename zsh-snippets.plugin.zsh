declare -A expandableMap # Initialize an associative array called expandableMap

als() {
  alias "$1"="$2"
}

expansion() {
  expandableMap[$1]="$2 ^"
}

snippet() {
  als "$1" "$2"
  expansion "$1" "$2"
}

expand() {
  expandable=${expandableMap[$LBUFFER]}

  if [[ -n "$expandable" ]] # If expandable is not an empty string...
  then
    LBUFFER=${expandable[(ws:^:)1]} # Then split expandable around the first ^
    RBUFFER=${expandable[(ws:^:)2]} # and set the buffers equal to the two parts
  else
    zle self-insert # Otherwise, just send a normal keypress
  fi
}

zle -N expand
bindkey " " expand