#! /bin/zsh

init_dirs() {
    # 创建各环境变量的目录
    mkdir -p ${XDG_CONFIG_HOME} ${XDG_CACHE_HOME} ${XDG_DATA_HOME} ${XDG_STATE_HOME} # 创建 XDG 目录
    mkdir -p ${CONDA_ENVS_DIRS} # conda 有关目录
    mkdir -p ${HISTFILE%/*} ${_ZL_DATA%/*} # zsh 有关目录
    mkdir -p ${XDG_DATA_HOME}/npm ${XDG_CACHE_HOME}/npm # npm 有关目录
    mkdir -p ${GOPATH} ${GOBIN} ${_JAVA_OPTIONS#*=} ${GNUPGHOME} ${CARGO_HOME} # 其他程序
    if [ ! -e "$XDG_STATE_HOME/python/history" ]; then
        mkdir -p $XDG_STATE_HOME/python
        touch $XDG_STATE_HOME/python/history
    fi
    mkdir -p $XDG_CACHE_HOME/zsh # zsh 性能分析目录
}

init_zsh() {
    # 下载 ohmyzsh
    omz_git_url="https://github.com/ohmyzsh/ohmyzsh.git"
    if [ -n $OMZ ]; then
        if [ -e $OMZ ]; then
            echo -n "OMZ 已经存在，是否覆盖？(y/[n]) ："
            read answer
            if [ "$answer" = "y" ]; then
                trash $OMZ
                git clone $omz_git_url $OMZ
                cp zsh/file_preview.sh zsh/img_preview.sh $OMZ/lib
            fi
        else
            git clone $omz_git_url $OMZ
            cp zsh/file_preview.sh zsh/img_preview.sh $OMZ/lib
        fi
    else
        echo "OMZ 环境变量不存在！"
        exit 1
    fi

    # 创建 ZDOTDIR 变量指定 zsh 配置配件路径
    if [ -z $ZDOTDIR ]; then
        ZDOTDIR=$HOME/.config/zsh
        echo -n "是否对所有用户有效（需要root权限）？(y/[n])："
        read answer
        if [ "$answer" = "y" ]; then
            echo "写入 ZDOTDIR 环境变量到 /etc/zsh/zshenv···"
            if [ $EUID -eq 0 ]; then
                echo "export ZDOTDIR=$ZDOTDIR" >> /etc/zsh/zshenv
            else
                echo "export ZDOTDIR=$ZDOTDIR" | sudo tee -a /etc/zsh/zshenv > /dev/null
            fi
        else
            echo "写入 ZDOTDIR 环境变量到 $HOME/.zshenv···"
            echo "export ZDOTDIR=$ZDOTDIR" >> $HOME/.zshenv
        fi
    fi

    # 安装 zsh 插件
    omz_plugin_path=$OMZ/custom/plugins
    if [ ! -e $omz_plugin_path/fzf-tab ]; then
        echo "克隆 fzf-tab 插件···"
        git clone https://github.com/Aloxaf/fzf-tab $omz_plugin_path/fzf-tab
    fi
    if [ ! -e $omz_plugin_path/zsh-fzf-history-search ]; then
        echo "克隆 zsh-fzf-history-search"
        git clone https://github.com/joshskidmore/zsh-fzf-history-search.git $omz_plugin_path/zsh-fzf-history-search
    fi

    if [ ! -e $omz_plugin_path/z.lua ]; then
        echo "克隆 z.lua 插件···"
        git clone https://github.com/skywind3000/z.lua.git $omz_plugin_path/z.lua
    fi
    if [ ! -e $omz_plugin_path/zsh-autosuggestions ]; then
        echo "克隆 zsh-autosuggestions 插件···"
        git clone https://github.com/zsh-users/zsh-autosuggestions $omz_plugin_path/zsh-autosuggestions
    fi
    if [ ! -e $omz_plugin_path/zsh-completions ]; then
        echo "克隆 zsh-completions 插件···"
        git clone https://github.com/zsh-users/zsh-completions $omz_plugin_path/zsh-completions
    fi
    if [ ! -e $omz_plugin_path/zsh-history-substring-search ]; then
        echo "克隆 zsh-history-substring-search 插件···"
        git clone https://github.com/zsh-users/zsh-history-substring-search $omz_plugin_path/zsh-history-substring-search
    fi
    if [ ! -e $omz_plugin_path/zsh-syntax-highlighting ]; then
        echo "克隆 zsh-syntax-highlighting 插件···"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $omz_plugin_path/zsh-syntax-highlighting
    fi
    if [ ! -e $omz_plugin_path/conda-zsh-completion ]; then
        echo "克隆 conda-zsh-completion"
        git clone https://github.com/conda-incubator/conda-zsh-completion.git $omz_plugin_path/conda-zsh-completion
    fi
    # 安装 zsh 主题
    omz_plugin_path=$OMZ/custom/themes
    if [ ! -e $omz_plugin_path/powerlevel10k ]; then
        echo "克隆 powerlevel10k 主题···"
        git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git $omz_plugin_path/powerlevel10k
    fi
}

init_zsh_offline() {
    ZDOTDIR=$HOME/.config/zsh

    [[ -e $ZDOTDIR ]] || cp -r zsh $(dirname $ZDOTDIR)
    [[ -e $OMZ ]] || unzip resources/ohmyzsh-master.zip && mv ohmyzsh-master $OMZ && cp zsh/file_preview.sh zsh/img_preview.sh $OMZ/lib

    omz_plugin_path=$OMZ/custom/plugins
    [[ -e $omz_plugin_path/fzf-tab ]] || unzip resources/fzf-tab-master.zip && mv fzf-tab-master $omz_plugin_path/fzf-tab
    [[ -e $omz_plugin_path/zsh-fzf-history-search ]] || unzip resources/zsh-fzf-history-search-master.zip && mv zsh-fzf-history-search-master $omz_plugin_path/zsh-fzf-history-search
    [[ -e $omz_plugin_path/z.lua ]] || unzip resources/z.lua-master.zip && mv z.lua-master $omz_plugin_path/z.lua
    [[ -e $omz_plugin_path/zsh-autosuggestions ]] || unzip resources/zsh-autosuggestions-master.zip && mv zsh-autosuggestions-master $omz_plugin_path/zsh-autosuggestions
    [[ -e $omz_plugin_path/zsh-completions ]] || unzip resources/zsh-completions-master.zip && mv zsh-completions-master $omz_plugin_path/zsh-completions
    [[ -e $omz_plugin_path/zsh-history-substring-search ]] || unzip resources/zsh-history-substring-search-master.zip && mv zsh-history-substring-search-master $omz_plugin_path/zsh-history-substring-search
    [[ -e $omz_plugin_path/zsh-syntax-highlighting ]] || unzip resources/zsh-syntax-highlighting-master.zip && mv zsh-syntax-highlighting-master $omz_plugin_path/zsh-syntax-highlighting
    [[ -e $omz_plugin_path/conda-zsh-completion ]] || unzip resources/conda-zsh-completion-master.zip && mv conda-zsh-completion-master $omz_plugin_path/conda-zsh-completion

    omz_theme_path=$OMZ/custom/themes
    [[ -e $omz_theme_path/powerlevel10k ]] || unzip resources/powerlevel10k-master.zip && mv powerlevel10k $omz_theme_path/powerlevel10k
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
    if [ ! -z $1 ]; then
        if [ ! -z $2 ] && [ "$2" != "sudo" ]; then
            echo "第二个参数只能为 sudo，不能为 $2"
            exit 1
        fi

        file=$(echo $1 | sed -E 's#.*/([^/]+)/([^/]+)$#\1/\2#')
        if [ -e $proj_dir/$file ]; then
            echo -n "$1 配置文件已存在，是否覆盖？(y/[n])："
            read answer
            if [ "$answer" = "y" ]; then
                $2 trash $1
                $2 cp $proj_dir/$file $1
            fi
        else
            echo "$1/$file 配置文件不存在，创建···"
            $2 cp $proj_dir/$file $1
        fi
    else
        echo "缺少参数，或者参数为空！"
    fi
}

updateAll() {
    # 更新ohmyzsh
    if [ -e $OMZ ]; then
        cd $OMZ && git pull && cd -
    fi

    updateDir $ZDOTDIR
    updateDir $XDG_CONFIG_HOME/conda
    updateDir $XDG_CONFIG_HOME/pip
    updateDir $XDG_CONFIG_HOME/wget
    updateDir $XDG_CONFIG_HOME/npm
    updateDir $XDG_CONFIG_HOME/python
    updateDir $XDG_CONFIG_HOME/nvim
    updateDir $XDG_CONFIG_HOME/git

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
        init_dirs && init_zsh
        ;;
    initOffline)
        init_dirs && init_zsh_offline
        ;;
    updateFile)
        updateFile $2
        ;;
    updateDir)
        updateDir $2
        ;;
    updateAll)
        updateAll
        ;;
    *)
        init_dirs && init_zsh && updateAll
        ;;
esac