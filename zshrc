if [[ "$(uname -s)" = "Darwin" ]]; then
  # Mac with Apple Silicon
  alias xcp=pbcopy
  alias brew='/opt/homebrew/bin/brew' # ARM Homebrew
  alias ibrew='arch -x86_64 /usr/local/bin/brew' # X86 Homebrew
else
  alias xcp='xclip -selection clipboard'
fi

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vi'
else
  export EDITOR='vim'
fi

if [[ $TERM = "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
fi


ansi_color=(red green yellow blue cyan magenta)
bracket_color=${ansi_color[$((1 + $RANDOM % ${#ansi_color[*]}))]}
export PS1="%{$fg[$bracket_color]%}%n%{$reset_color%}@%m: %(5~|%-1~/.../%2~|%3~)%(!.#.$) "
#export PS1="%{$fg[$bracket_color]%}[%{$reset_color%}%m %(5~|%-1~/.../%3~|%4~)%{$fg[$bracket_color]%}]%{$reset_color%}%(!.#.$) "

# alias npm=cnpm
alias lgit=lazygit
alias cl=clear
alias fy='fy -S'
alias fanyi='fanyi -S'
myproxy() {
  export all_proxy=http://127.0.0.1:7890;
  export http_proxy=http://127.0.0.1:7890;
  export https_proxy=http://127.0.0.1:7890;
}
unproxy() {
  export all_proxy=;
  export http_proxy=;
  export https_proxy=;
}

alias v=nvim

# export NVM_DIR="$HOME/.nvm"
  # [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  # [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

mkcd() { mkdir -p "$@" && cd "$@"; }

alias rmds='find . | egrep "DS|dSYM" | xargs rm'
alias termcolor='alacritty-colorscheme -C ~/.config/alacritty/base16-alacritty/colors'

export PATH=$PATH:/Users/sduby/.config/alacritty/color_scripts:/Users/sduby/Library/Python/3.9/bin

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

