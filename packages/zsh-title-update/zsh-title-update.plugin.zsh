function update_title() {
  if [[ -n "$TMUX" ]] && [[ $TERM == screen* || $TERM == tmux* ]]; then
    print -n "\ek${(%)1}\e\\"
  elif [[ "$TERM" =~ "screen*" ]]; then
    print -n "\ek${(%)1}\e\\"
  elif [[ "$TERM" =~ "xterm*" || "$TERM" =~ "alacritty|wezterm" || "$TERM" =~ "st*" ]]; then
    print -n "\e]0;${(%)1}\a"
  elif [[ "$TERM" =~ "^rxvt-unicode.*" ]]; then
    printf '\33]2;%s:%s\007' ${(%)1}
  fi
}

# called just before the prompt is printed
function _zsh_title__precmd() {
  update_title "%20<...<%~"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_title__precmd
