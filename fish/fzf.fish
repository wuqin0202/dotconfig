# ============================ FZF Configuration ============================

set -gx RUNEWIDTH_EASTASIAN 0
set -gx FZF_DEFAULT_OPTS "--height 12 --scrollbar=▌▐ --info=inline-right --layout=reverse --history=$XDG_STATE_HOME/fish/fzf_history"
set -gx FZF_DEFAULT_COMMAND "fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f"

set -gx FZF_PREVIEW_COMMAND "source $__fish_config_dir/fzf.fish && fzf_file_preview {}"

# ============================ FZF File Preview Function ============================

function fzf_file_preview -d "Preview files for fzf"
    set target $argv[1]

    # Directory preview
    if test -d "$target"
        if command -v exa >/dev/null 2>&1
            exa -l --no-user --no-time --icons --no-permissions --no-filesize "$target"
        else if command -v ls >/dev/null 2>&1
            ls --color=always "$target" 2>/dev/null; or ls -G "$target"
        end
        return
    end

    set mime (file -bL --mime-type "$target")
    set category (string split / $mime)[1]

    switch $category
        case text
            if command -v bat >/dev/null 2>&1
                bat -p --color=always "$target"
            else
                cat "$target"
            end 2>/dev/null | head -1000

        case image
            if command -v chafa >/dev/null 2>&1
                chafa "$target"
            else if command -v img2txt >/dev/null 2>&1
                img2txt "$target"
            end

        case '*'
            echo "$target is a $category file"
            if command -v bat >/dev/null 2>&1
                bat -p --color=always "$target"
            else
                cat "$target"
            end 2>/dev/null | head -1000
    end
end
