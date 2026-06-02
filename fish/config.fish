# ============================ Fish Configuration ============================
# Equivalent of .zshrc — sources all modular config files

# Source all config modules
source $__fish_config_dir/envs.fish
source $__fish_config_dir/aliases.fish
source $__fish_config_dir/proxy.fish

# ============================ fzf ============================
if command -v fzf >/dev/null 2>&1
    fzf --fish | source
end

# ============================ zoxide ============================
if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source
end

# ============================ starship ============================
if command -v starship >/dev/null 2>&1
    starship init fish | source
end

# ============================ atuin ============================
if command -v atuin >/dev/null 2>&1
    atuin init fish --disable-up-arrow | source
end

# ============================ conda ============================
# Run `conda init fish` to auto-generate conda.fish in conf.d/
# The generated file typically lives at:
#   ~/.config/fish/conf.d/conda.fish
# or
#   ~/miniforge3/etc/fish/conf.d/conda.fish
if test -f $HOME/miniforge3/etc/fish/conf.d/conda.fish
    source $HOME/miniforge3/etc/fish/conf.d/conda.fish
else if test -f $HOME/miniforge3/etc/profile.d/conda.sh
    # Fallback: initialize conda for fish
    $HOME/miniforge3/bin/conda init fish >/dev/null 2>&1
    if test -f $HOME/.config/fish/conf.d/conda.fish
        source $HOME/.config/fish/conf.d/conda.fish
    end
end

# ============================ Key Bindings ============================
# Ctrl+U — delete from cursor to beginning of line
bind \cU backward-kill-line

# ============================ Git Functions ============================
function git_current_branch -d "Get the current git branch name"
    command git symbolic-ref --quiet --short HEAD 2>/dev/null
    or command git rev-parse --short HEAD 2>/dev/null
end
