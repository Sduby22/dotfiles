if status is-interactive
  source ~/.profile
  source ~/.aliasrc

  if type -q starship

    starship init fish | source
  end

  # Commands to run in interactive sessions can go here
  if [ "$(uname -s)" = "Darwin" ];
    alias xcp=pbcopy
    alias brew='/opt/homebrew/bin/brew' # ARM Homebrew
    alias ibrew='arch -x86_64 /usr/local/bin/brew' # X86 Homebrew
  else
    alias xcp='xclip -selection clipboard'
  end

  if [ $TERM = "xterm-kitty" ];
    alias ssh="kitty +kitten ssh"
  end

  function myproxy
    export ALL_PROXY=http://127.0.0.1:7890;
    export HTTP_PROXY=http://127.0.0.1:7890;
    export HTTPS_PROXY=http://127.0.0.1:7890;
  end

  function unproxy
    export ALL_PROXY=;
    export HTTP_PROXY=;
    export HTTPS_PROXY=;
  end

  function mkcd
    mkdir -p $argv && cd $argv; 
  end

  #myproxy

  set -Ux PYENV_ROOT $HOME/.pyenv
  set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
  pyenv init - | source
  pyenv virtualenv-init - | source
  thefuck --alias | source

end
