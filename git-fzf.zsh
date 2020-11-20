function __git-fzf() {
  local preview='echo {} | \
    awk "
      \$1==\"A\"   { print \"git diff --color --staged \"\$2 }
      \$1==\"M\"   { print \"git diff --color \"\$2 }
      \$1==\"\?\?\"{ print \"echo \\\"Untracked file\\\"\" }" | \
    xargs -L1 -I{} zsh -c {}'

  local selected=$(__git-fzf__git_status | fzf -m --ansi --preview="$preview")
  if [[ -n "$selected" ]]; then
    selected=$(tr '\n' ' ' <<< "$selected")
    echo $selected
  fi
}

function __git-fzf__git_status() {
  unbuffer git status -s | \
    awk '
      match($1, /\x1b\[[0-9;]*mA/)    { print    substr($0, RSTART, RLENGTH)"\x1b\[0m  "$2 }
      match($1, /\x1b\[[0-9;]*mM/)    { print " "substr($0, RSTART, RLENGTH)"\x1b\[0m " $2 }
      match($1, /\x1b\[[0-9;]*m\?\?/) { print    substr($0, RSTART, RLENGTH)"\x1b\[0m " $2 }
    '
}

function git-fzf-widget() {
  local selected=$(__git-fzf)
  if [[ -n "$selected" ]]; then
    BUFFER="${BUFFER}${selected}"
    zle redisplay
  fi
}

zle -N git-fzf-widget
