PROMPT='%{$fg_bold[cyan]%}%n@%m %{$fg[yellow]%}%~%} $(git_prompt_info)'
PROMPT+="%(?:%{$fg_bold[green]%}%(!.#.$) :%{$fg_bold[red]%}%(!.#.$) )%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "