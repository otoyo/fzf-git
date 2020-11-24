function __fzf-git() {
  local preview='echo {} | \
    awk "
      \$0 ~ /^[AMD] / { print \"git diff --color --staged \"\$2 }
      \$0 ~ /^ [AMD]/ { print \"git diff --color \"\$2 }
      \$0 ~ /^\?\? /  { print \"echo \\\"Untracked file\\\"\" }" | \
    xargs -L1 -I{} zsh -c {}'

  local selected=$(__fzf-git__git_status | fzf -m --ansi --preview="$preview" | awk '{ print $2 }')
  if [[ -n "$selected" ]]; then
    selected=$(tr '\n' ' ' <<< "$selected")
    echo $selected
  fi
}

function __fzf-git__git_status() {
  unbuffer git status -s | \
    awk '{
      # ?? file
      if (match($0, /^\x1b\[[0-9;]*m\?\?\x1b\[m/)) {
        print substr($0, RSTART, RLENGTH)" "$2
      } else {
        # MM file
        if (match($0, /^\x1b\[[0-9;]*m[AMD]\x1b\[m\x1b\[[0-9;]*m[AMD]\x1b\[m/)) {
          match($1, /^\x1b\[[0-9;]*m[AMD]\x1b\[m/)
          print substr($0, RSTART, RLENGTH)"  "$2

          match($1, /\x1b\[[0-9;]*m[AMD]\x1b\[m$/)
          print " "substr($0, RSTART, RLENGTH)" "$2
        # M  file
        } else if (match($0, /^\x1b\[[0-9;]*m[AMD]\x1b\[m/)) {
          print substr($0, RSTART, RLENGTH)"  "$2
        #  M file
        } else if (match($0, /^ \x1b\[[0-9;]*m[AMD]\x1b\[m/)) {
          print substr($0, RSTART, RLENGTH)" "$2
        }
      }
    }'
}

function fzf-git-widget() {
  local selected=$(__fzf-git)
  if [[ -n "$selected" ]]; then
    BUFFER="${BUFFER}${selected}"
    zle redisplay
  fi
}

zle -N fzf-git-widget
