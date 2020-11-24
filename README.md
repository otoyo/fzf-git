# fzf-git

fzf-git makes Git files selection easy.

![fzf-git](https://user-images.githubusercontent.com/1063435/100101343-77d71d00-2ea5-11eb-803f-3be1b1dfc232.gif)


## Requirements

* Zsh
* Git
* [fzf](https://github.com/junegunn/fzf)
* [expect](https://formulae.brew.sh/formula/expect)

## Installation

```sh
# Install requirements
$ brew install fzf
$ brew install expect

$ cd ~
$ git clone git@github.com:otoyo/fzf-git.git
```

Add the following into `~/.zshrc`
```sh
[ -d ~/fzf-git ] && \
  source ~/fzf-git/fzf-git.zsh &&  \
  bindkey '^G' fzf-git-widget
```

Now you cat use fzf-git by Ctrl+G in the Git repositories.
