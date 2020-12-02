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
  source ~/fzf-git/fzf-git.zsh && \
  bindkey '^G' fzf-git-widget && \
  bindkey '^H' fzf-git-commit-widget
```

And reload `~/.zshrc`
```sh
$ source ~/.zshrc
```

Now you can use fzf-git by `Ctrl+G` and `Ctrl+H` in the Git repositories.

And, you can use multi-select by pressing `Tab` in fzf console.

## Widgets

* `fzf-git-widget`: Search files from `git status`
* `fzf-git-commit-widget`: Search commits from `git log`

## Update

Move to fzf-git.git repository and pull.

```sh
$ cd ~/fzf-git
$ git pull origin master
```

## Contoribution

Feel free to open a Pull Requests ;)
