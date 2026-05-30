# ============================ Zinit ============================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
source "$ZINIT_HOME/zinit.zsh"


# ============================ Completions ============================
zstyle ':completion::complete:*' use-cache 1

# conda completion config
zstyle ':conda_zsh_completion:*' use-groups true
zstyle ':conda_zsh_completion:*' show-unnamed true
zstyle ':conda_zsh_completion:*' sort-envs-by-time true
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit ice blockf atpull'zinit creinstall -q .'
zinit light conda-incubator/conda-zsh-completion


# ============================ compinit cache ============================
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"

autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"
zinit cdreplay -q


# ============================ fzf-tab：必须在 compinit 后 ============================
zinit ice wait lucid
zinit light Aloxaf/fzf-tab


# ============================ Oh My Zsh git ============================
git_current_branch() {
  command git symbolic-ref --quiet --short HEAD 2>/dev/null ||
  command git rev-parse --short HEAD 2>/dev/null
}
zinit ice wait lucid
zinit snippet OMZP::git


# ============================ Autosuggestions ============================
zinit light zsh-users/zsh-autosuggestions


# ============================ Syntax highlighting ============================
zinit light zsh-users/zsh-syntax-highlighting


# ============================ History search ============================
zinit ice atload'
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  bindkey "^[[A" history-substring-search-up
  bindkey "^[[B" history-substring-search-down
'
zinit light wuqin0202/zsh-history-prefix-string-search