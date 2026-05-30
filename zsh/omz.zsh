zstyle ':omz:update' mode disabled # 禁用 oh-my-zsh 的自动更新

ZSH=$OMZ
ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_AUTO_TITLE=true # 是否禁用自动设置终端标题
plugins=( # 插件
    git
    fzf-tab
    zsh-fzf-history-search
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-completions
    conda-zsh-completion
    z.lua
    zsh-syntax-highlighting
)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src # 见 https://github.com/zsh-users/zsh-completions#oh-my-zsh
source $OMZ/oh-my-zsh.sh
source $ZDOTDIR/fzf.zsh
zstyle ':completion::complete:*' use-cache 1 # conda-zsh-completion 启用完成缓存