typeset -Ag abbreviations
abbreviations=()

just_alias() {
  alias $1="$2"
} 

just_expansion() {
  if [[ "$2" == *\^* ]]
  then
    abbreviations[$1]="$2"
  else
    abbreviations[$1]="$2 ^"
  fi
}

snippet() {
  just_alias $1 $2
  just_expansion $1 $2
}

magic-abbrev-expand() {
  local MATCH
  TEMP="$LBUFFER"
  SNIPPET=${abbreviations[$LBUFFER]}

  if [[ -n "$SNIPPET" ]]
  then
    LBUFFER=${SNIPPET[(ws:^:)1]}
    RBUFFER=${SNIPPET[(ws:^:)2]}
  else
    zle self-insert
  fi
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand