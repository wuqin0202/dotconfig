export RUNEWIDTH_EASTASIAN=0
export FZF_DEFAULT_OPTS="--height 12 --scrollbar=▌▐ --info=inline-right --layout=reverse --history=${XDG_STATE_HOME}/zsh/fzf_history"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f"
export ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=1
export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0
export ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0

FZF_TAB_PLUGIN_DIR=$ZSH_PLUGINS_DIR/fzf-tab

export FZF_PREVIEW_COMMAND="source $ZDOTDIR/fzf.zsh && fzf_file_preview {}"

_fzf_start_ueberzug() {
    local uebezug_fifo="$1"
    mkfifo "$uebezug_fifo"
    <"$uebezug_fifo" ueberzug layer --parser bash --silent &
    exec 3>"$uebezug_fifo"
}

_fzf_finalize_ueberzug() {
    local uebezug_fifo="$1"
    exec 3>&-
    rm -f "$uebezug_fifo" >/dev/null 2>&1
    jobs -p | xargs -r kill >/dev/null 2>&1
    command -v killall >/dev/null 2>&1 && killall ueberzug >/dev/null 2>&1
}

_fzf_draw_preview() {
    local uebezug_fifo="$1"
    local preview_id="$2"
    local target="$3"
    local x
    local y

    [[ -f "$FZF_TAB_PLUGIN_DIR/modules/ueberzug/cursor_pos" ]] || return 1
    source "$FZF_TAB_PLUGIN_DIR/modules/ueberzug/cursor_pos"
    x=$((COLUMNS / 2 + 2))
    y=$((row + 2))
    if [ $y -gt $((LINES - 11)) ]; then
        y=$((LINES - 11))
    fi

    >"$uebezug_fifo" declare -A -p cmd=( \
        [action]=add [identifier]="$preview_id" \
        [x]="$x" [y]="$y" \
        [width]="$((COLUMNS / 2 - 2))" [height]="10" \
        [scaler]=forced_cover [scaling_position_x]=0.5 [scaling_position_y]=0.5 \
        [path]="$target")
}

zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':completion:*:descriptions' format "[%d]"
zstyle ':fzf-tab:*' group-colors $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m' $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m'
zstyle ':fzf-tab:*' prefix ''
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[ "$group" = "process ID" ] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:yay:*' fzf-preview 'yay -Qi $word || yay -Si $word'
zstyle ':fzf-tab:complete:pacman:*' fzf-preview 'pacman -Qi $word || pacman -Si $word'
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview '[ -f "$realpath" ] && git diff --color=always $word || git log --color=always $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'source $ZDOTDIR/fzf.zsh && fzf_file_preview ${(Q)realpath}'
zstyle ':fzf-tab:complete:*:*' fzf-flags --height=12

fzf_img_preview() {
    local uebezug_fifo
    local preview_id

    uebezug_fifo="$(mktemp --dry-run --suffix "fzf-$$-ueberzug")" || return 1
    preview_id="preview"

    trap '_fzf_finalize_ueberzug "$uebezug_fifo"' EXIT
    _fzf_start_ueberzug "$uebezug_fifo"
    _fzf_draw_preview "$uebezug_fifo" "$preview_id" "$1"
    sleep 999999
}

fzf_file_preview() {
    local target="$1"
    local mime
    local category

    if [ -d "$target" ]; then
        exa -l --no-user --no-time --icons --no-permissions --no-filesize "$target" 2>/dev/null \
            || ls --color=always "$target" 2>/dev/null \
            || ls -G "$target"
        return
    fi

    mime=$(file -bL --mime-type "$target")
    category=${mime%%/*}

    if [ "$category" = text ]; then
        (bat -p --color=always "$target" || cat "$target") 2>/dev/null | head -1000
    elif [ "$category" = image ]; then
        if command -v ueberzug >/dev/null 2>&1; then
            fzf_img_preview "$target"
        else
            img2txt "$target"
        fi
    else
        echo "$target is a $category file"
        (bat -p --color=always "$target" || cat "$target") 2>/dev/null | head -1000
    fi
}

