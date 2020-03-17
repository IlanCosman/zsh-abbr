declare -A expandableMap # Initialize an associative array called expandableMap

abbr() {
  local arg1=${1[(ws:=:)1]}
  local arg2=${1[(ws:=:)2]}
  
  alias "$arg1"="$arg2" #This is done only for syntax highlighting purposes
  
  expandableMap[$arg1]="$arg2"
}

expand() {
  expandable=${expandableMap[$LBUFFER]}
  
  if [[ -n "$expandable" ]] ; then # If expandable is not an empty string
    if [[ "$expandable" == *"^"* ]] ; then # If expandable contains a ^
      LBUFFER=${expandable[(ws:^:)1]} # Then split expandable around the first ^
      RBUFFER=${expandable[(ws:^:)2]} # and set the R/L buffers equal to the two parts
    else
      LBUFFER="$expandable " # If no ^, just set the left buffer equal to expandable
      if [[ "$1" == "Enter" ]] ; then # If passed "Enter", accept the line
        zle accept-line
      fi
    fi
  else # If expandable is an empty string
    if [[ "$1" == "Enter" ]] ; then # If passed "Enter", accept the line
      zle accept-line
    else
      zle self-insert #Otherwise, send a normal keypress
    fi
  fi
}

enterExpand() {
  expand "Enter"
}

zle -N expand
zle -N enterExpand

bindkey " " expand
bindkey "^M" enterExpand
