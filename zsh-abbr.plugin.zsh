declare -A expandableMap # Initialize an associative array called expandableMap

abbr() {
  arg1=${1[(ws:=:)1]}
  arg2=${1[(ws:=:)2]}

  expandableMap[$arg1]="$arg2"
}

spaceExpand() {
  expandable=${expandableMap[$LBUFFER]}

  if [[ -n "$expandable" ]] # If expandable is not an empty string
  then
    if [[ "$expandable" == *"^"* ]] #If expandable contains a ^
    then
      LBUFFER=${expandable[(ws:^:)1]} # Then split expandable around the first ^
      RBUFFER=${expandable[(ws:^:)2]} # and set the R/L buffers equal to the two parts
    else
      LBUFFER="$expandable " #If no ^, just set the left buffer equal to expandable
    fi
  else
    zle self-insert # If expandable is an empty string, just send a normal keypress   
  fi
}

enterExpand() {
  expandable=${expandableMap[$LBUFFER]}

  if [[ -n "$expandable" ]]
  then
    if [[ "$expandable" == *"^"* ]]
    then
      LBUFFER=${expandable[(ws:^:)1]}
      RBUFFER=${expandable[(ws:^:)2]}
    else
      LBUFFER="$expandable "
      zle accept-line
    fi
  else
    zle accept-line 
  fi
}

zle -N spaceExpand
zle -N enterExpand

bindkey " " spaceExpand
bindkey "^M" enterExpand
