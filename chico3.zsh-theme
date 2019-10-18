function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

PS1='%{$FG[245]%}${PWD/#$HOME/~}%{$reset_color%}%p$(git_prompt_info)
%{$FG[245]%}$%{$reset_color%} '

PS2='%{$FG[245]%}>%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" "
#ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG_BOLD[003]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[002]%}"
