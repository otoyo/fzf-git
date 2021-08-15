function __fzf-git() {
  local preview='echo {} | \
    awk "
      \$0 ~ /^[AM] / { print \"git diff --color --staged \"\$2 }
      \$0 ~ /^ [AM]/ { print \"git diff --color \"\$2 }
      \$0 ~ /^D /    { print \"git diff --color --staged -- \"\$2 }
      \$0 ~ /^ D/    { print \"git diff --color -- \"\$2 }
      \$0 ~ /^\?\? / { print \"echo \\\"Untracked file\\\"\" }" | \
    xargs -L1 -I{} zsh -c {}'

  local selected=$(__fzf-git__git_status | fzf -m --ansi --preview="$preview" | awk '{ print $2 }')
  if [[ -n "$selected" ]]; then
    selected=$(tr '\n' ' ' <<< "$selected")
    selected=$(echo $selected | sed -e 's/\([][\(\)]\)/\\\1/g')
    echo $selected
  fi
}

function __fzf-git-commit() {
  local source_git_branch='echo "Press => to select commits" && unbuffer git branch'

  local source_git_log='echo "Press <= to select branch" && \
    unbuffer git --no-pager log --pretty=format:"%C(auto)%h %ad %an - %s%d" --date=format:"%Y-%m-%d %H:%M:%S"'

  local preview=' \
    if [[ {} =~ " " ]] ; then \
      echo {} | awk "{ print \"git diff --color \"\$1\"~1 \" \$1 }" | xargs -L1 -I{} zsh -c {}; \
    else \
      '$source_git_log' {1}; \
    fi'

  local selected=$(zsh -c $source_git_log | \
    fzf --ansi --multi --reverse --no-sort --preview "$preview" --header-lines 1 \
      --bind 'left:reload('$source_git_branch')' \
      --bind 'right:reload('$source_git_log' {1})' \
      --bind 'tab:toggle+up' | \
    sed -e 's/\* //g' | awk '{ print $1 }')
  if [[ -n "$selected" ]]; then
    selected=$(tr '\n' ' ' <<< "$selected" | sed -e 's/ *$//')
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

function fzf-git-commit-widget() {
  local selected=$(__fzf-git-commit)
  if [[ -n "$selected" ]]; then
    BUFFER="${BUFFER}${selected}"
    zle redisplay
  fi
}

zle -N fzf-git-widget
zle -N fzf-git-commit-widget
