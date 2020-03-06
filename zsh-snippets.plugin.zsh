typeset -Ag abbreviations
abbreviations=()

als() {
  alias "$1"="$2"
}

expansion() {
  abbreviations[$1]="$2 ^"
}

snippet() {
  als "$1" "$2"
  expansion "$1" "$2"
}

magic-abbrev-expand() {
  local MATCH
  SNIPPET=${abbreviations[$LBUFFER]}

  if [[ -n "$SNIPPET" ]]
  then
    LBUFFER=${SNIPPET[(ws:^:)1]}
    RBUFFER=${SNIPPET[(ws:^:)2]}
  else
    zle self-insert
  fi
}

zle -N magic-abbrev-expand
bindkey " " magic-abbrev-expand