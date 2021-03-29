PROMPT='%{$fg_bold[cyan]%}%n@%m %{$fg[yellow]%}%~%} $(git_prompt_info)'
PROMPT+="%(?:%{$fg_bold[green]%}%(!.#.$) :%{$fg_bold[red]%}%(!.#.$) )%{$reset_color%}"