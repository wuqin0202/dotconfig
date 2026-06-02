#! /bin/zsh

init_dirs() {
    # 创建各环境变量的目录
    mkdir -p ${XDG_CONFIG_HOME} ${XDG_CACHE_HOME} ${XDG_DATA_HOME} ${XDG_STATE_HOME} # 创建 XDG 目录
    mkdir -p ${HISTFILE%/*} # zsh 历史命令目录
    mkdir -p ${XDG_DATA_HOME}/atuin # atuin 历史数据库目录
    mkdir -p ${XDG_DATA_HOME}/npm ${XDG_CACHE_HOME}/npm # npm 有关目录
    mkdir -p ${GOPATH} ${GOBIN} ${_JAVA_OPTIONS#*=} ${GNUPGHOME} ${CARGO_HOME} # 其他程序
    if [ ! -e "$XDG_STATE_HOME/python/history" ]; then
        mkdir -p $XDG_STATE_HOME/python
        touch $XDG_STATE_HOME/python/history
    fi
    mkdir -p $XDG_CACHE_HOME/zsh # zsh 性能分析目录
}

init_zsh() {
    ZDOTDIR=$HOME/.config/zsh
    local os_name=$(uname -s)

    # 复制 zsh 配置文件
    [[ -e $ZDOTDIR ]] && trash $ZDOTDIR
    cp -r zsh $ZDOTDIR

    # 安装 zinit（在线从 GitHub 克隆）
    zinit_home=$XDG_DATA_HOME/zinit/zinit.git
    if [[ ! -e $zinit_home ]]; then
        mkdir -p $(dirname $zinit_home)
        git clone https://github.com/zdharma-continuum/zinit.git $zinit_home
    fi

    # 安装 starship
    if ! command -v starship > /dev/null 2>&1; then
        if [[ "$os_name" == "Darwin" ]]; then
            brew install starship
        elif [[ "$os_name" == "Linux" ]]; then
            curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin
        fi
    fi

    # 安装 zoxide
    if ! command -v zoxide > /dev/null 2>&1; then
        if [[ "$os_name" == "Darwin" ]]; then
            brew install zoxide
        elif [[ "$os_name" == "Linux" ]]; then
            curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh |
                sh -s -- \
                    --bin-dir ~/.local/bin \
                    --man-dir ~/.local/share/man
        fi
    fi

    # 安装 atuin
    if ! command -v atuin > /dev/null 2>&1; then
        if [[ "$os_name" == "Darwin" ]]; then
            brew install atuin
        elif [[ "$os_name" == "Linux" ]]; then
            curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
            mv "$HOME"/.atuin/bin/atuin* "$HOME"/.local/bin/
        fi
    fi
}

init_fish() {
    local fish_conf_dir=$XDG_CONFIG_HOME/fish
    local os_name=$(uname -s)

    # 复制 fish 配置文件
    [[ -e $fish_conf_dir ]] && trash $fish_conf_dir
    cp -r fish $fish_conf_dir
}

init_fish_offline() {
    local fish_conf_dir=$XDG_CONFIG_HOME/fish

    [[ -e $fish_conf_dir ]] || cp -r fish $(dirname $fish_conf_dir)
}

init_zsh_offline() {
    ZDOTDIR=$HOME/.config/zsh

    [[ -e $ZDOTDIR ]] || cp -r zsh $(dirname $ZDOTDIR)

    # 安装 zinit（需要预先下载 zinit 仓库）
    zinit_home=$XDG_DATA_HOME/zinit/zinit.git
    if [[ ! -e $zinit_home ]]; then
        mkdir -p $(dirname $zinit_home)
        [[ -e resources/zinit-master.zip ]] && unzip resources/zinit-master.zip && mv zinit-master $zinit_home
    fi

    # 离线安装 zinit 插件
    zsh_plugins_dir=$XDG_DATA_HOME/zinit/plugins
    [[ -e $zsh_plugins_dir/fzf-tab ]] || unzip resources/fzf-tab-master.zip && mv fzf-tab-master $zsh_plugins_dir/fzf-tab
    [[ -e $zsh_plugins_dir/zsh-autosuggestions ]] || unzip resources/zsh-autosuggestions-master.zip && mv zsh-autosuggestions-master $zsh_plugins_dir/zsh-autosuggestions
    [[ -e $zsh_plugins_dir/zsh-completions ]] || unzip resources/zsh-completions-master.zip && mv zsh-completions-master $zsh_plugins_dir/zsh-completions
    [[ -e $zsh_plugins_dir/zsh-syntax-highlighting ]] || unzip resources/zsh-syntax-highlighting-master.zip && mv zsh-syntax-highlighting-master $zsh_plugins_dir/zsh-syntax-highlighting
    [[ -e $zsh_plugins_dir/conda-zsh-completion ]] || unzip resources/conda-zsh-completion-master.zip && mv conda-zsh-completion-master $zsh_plugins_dir/conda-zsh-completion
    [[ -e $zsh_plugins_dir/zsh-history-prefix-string-search ]] || unzip resources/zsh-history-prefix-string-search-master.zip && mv zsh-history-prefix-string-search-master $zsh_plugins_dir/zsh-history-prefix-string-search
}

autoRootExec() {
    # 自动获取 root 权限执行命令
    if [ $EUID -eq 0 ]; then
        $@
    else
        sudo $@
    fi
}

updateDir() {
    # 应用整个目录配置
    # 参数：
    # $1: 目标安装路径，目录名需存在本项目下
    # $2（可选）：sudo
    if [ ! -z $1 ]; then
        if [ ! -z $2 ] && [ "$2" != "sudo" ]; then
            echo "第二个参数只能为 sudo，不能为 $2"
            exit 1
        fi
        local config_dir_path=$(basename $1)

        if [ -z $config_dir_path ]; then
            echo "未找到 $1 目录对应的配置目录！"
            exit 1
        fi

        if [ -e $1 ]; then
            echo -n "$1 目录已存在，是否覆盖？(y/[n])："
            read answer
            if [ "$answer" = "y" ]; then
                trash $1 $2
                $2 cp -r $config_dir_path $1
            fi
        else
            echo "$1 目录不存在，创建···"
            $2 cp -r $config_dir_path $1
        fi
    else
        echo "缺少参数，或者参数为空！"
    fi
}

updateFile() {
    # 应用单个文件配置
    # 参数：
    # $1: 目标安装路径，文件需存在本目录下
    # $2（可选）：sudo
    if [ -n "$1" ]; then
        if [ -n "$2" ] && [ "$2" != "sudo" ]; then
            echo "第二个参数只能为 sudo，不能为 $2"
            exit 1
        fi

        local target_path="$1"
        local file

        if [ "$(basename "$target_path")" = "starship.toml" ]; then
            file="starship.toml"
        else
            file=$(echo "$target_path" | sed -E 's#.*/([^/]+)/([^/]+)$#\1/\2#')
        fi

        if [ ! -e "$proj_dir/$file" ]; then
            echo "$proj_dir/$file 配置文件不存在！"
            exit 1
        fi

        if [ -e "$target_path" ]; then
            echo -n "$1 配置文件已存在，是否覆盖？(y/[n])："
            read answer
            if [ "$answer" = "y" ]; then
                $2 trash "$target_path"
                $2 cp "$proj_dir/$file" "$target_path"
            fi
        else
            echo "$1 配置文件不存在，创建···"
            $2 cp "$proj_dir/$file" "$target_path"
        fi
    else
        echo "缺少参数，或者参数为空！"
    fi
}

updateAll() {
    updateDir $ZDOTDIR
    updateDir $XDG_CONFIG_HOME/fish
    updateDir $XDG_CONFIG_HOME/atuin
    updateDir $XDG_CONFIG_HOME/conda
    updateDir $XDG_CONFIG_HOME/pip
    updateDir $XDG_CONFIG_HOME/wget
    updateDir $XDG_CONFIG_HOME/npm
    updateDir $XDG_CONFIG_HOME/python
    updateDir $XDG_CONFIG_HOME/nvim
    updateDir $XDG_CONFIG_HOME/git

    # starship 终端提示符配置
    updateFile $XDG_CONFIG_HOME/starship.toml

    [ -n $DISPLAY ] && has_gui="yes" # 有无 GUI
    [ -n $(uname -r | grep -i "wsl") ] && is_wsl="yes" # 是否为 WSL
    command -v docker > /dev/null 2>&1 && has_docker="yes" # 是否有 docker

    # 有 GUI 且不是 WSL 情况
    if [ "$has_gui" = "yes" ] && [ "$is_wsl" != "yes" ]; then
        updateDir $XDG_CONFIG_HOME/hypr
        updateDir $XDG_CONFIG_HOME/waybar
    fi

    # docker 配置文件安装
    if [ "$has_docker" = "yes" ]; then
        echo -n "是否安装 docker 配置文件？(y/[n])："
        read answer
        if [ "$answer" = "y" ]; then
            autoRootExec cp $proj_dir/config/docker/daemon.json /etc/docker/daemon.json
        fi
    fi
}

proj_dir=$(pwd)
if source $proj_dir/zsh/envs.zsh; then
    echo "source envs.zsh success"
else
    echo "source envs.zsh failed"
    exit 1
fi

case $1 in
    init)
        init_dirs && init_zsh && init_fish
        ;;
    initOffline)
        init_dirs && init_zsh_offline && init_fish_offline
        ;;
    initZsh)
        init_dirs && init_zsh
        ;;
    initZshOffline)
        init_dirs && init_zsh_offline
        ;;
    initFish)
        init_dirs && init_fish
        ;;
    initFishOffline)
        init_dirs && init_fish_offline
        ;;
    updateFile)
        updateFile $2 $3
        ;;
    updateDir)
        updateDir $2
        ;;
    updateAll)
        updateAll
        ;;
    *)
        init_dirs && init_zsh && init_fish && updateAll
        ;;
esac