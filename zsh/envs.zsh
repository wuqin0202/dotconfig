# XDG 桌面目录规范
export XDG_CONFIG_HOME=${HOME}/.config # 程序配置文件
export XDG_CACHE_HOME=$HOME/.cache # 程序缓存文件
export XDG_DATA_HOME=$HOME/.local/share # 程序数据文件
export XDG_STATE_HOME=$HOME/.local/state # 程序状态文件

# 默认程序
export EDITOR=nvim  # 默认编辑器

# conda
# export TERMINFO=/usr/share/terminfo # 解决 conda环境下 clear 报错

# zsh
export HISTFILE=${XDG_STATE_HOME}/zsh/zsh_history # zsh 历史命令记录
HISTSIZE=100000
SAVEHIST=100000
setopt append_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# go
export GOPATH=${XDG_DATA_HOME}/go # go get 下载的包的位置
export GOBIN=${GOPATH}/bin # go install 安装的可执行文件的位置

# java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# gnupg 凭证
export GNUPGHOME=${XDG_DATA_HOME}/gnupg

# rust
export CARGO_HOME=${XDG_DATA_HOME}/cargo

# gradle
export GRADLE_USER_HOME=${XDG_DATA_HOME}/gradle

# npm
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME}/npm/npm.conf

# cuda
if command -v nvidia-smi >/dev/null 2>&1; then
    export CUDA_CACHE_PATH=${XDG_CACHE_HOME}/nv
    export CUDA_PATH=/usr/local/cuda
    export CUDA_HOME=/usr/local/cuda
    export CUDNN_PATH=/usr/local/cuda/include
    export PATH="/usr/local/cuda/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
fi

# python
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/startup.py # python 启动时运行的文件
export PYTHONHISTFILE=$XDG_STATE_HOME/python/history # python 历史命令记录
export IPYTHONDIR=$XDG_STATE_HOME/python/ipython # ipython 目录
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib" # matplotlib 配置目录

# jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_DATA_DIR="$XDG_DATA_HOME/jupyter"
export JUPYTER_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$TMPDIR}/jupyter"

# less
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export LESSKEYIN="$XDG_CONFIG_HOME/lesskey"

# tensorflow
export KERAS_HOME=${XDG_CACHE_HOME}/keras

# mysql
export MYSQL_HISTFILE=${XDG_DATA_HOME}/mysql/mysql_history

# atuin
export ATUIN_DB_PATH=${XDG_DATA_HOME}/atuin/zsh-history.db

# wget
export WGETRC=${XDG_CONFIG_HOME}/wget/wgetrc

# qt
# export QT_DEBUG_PLUGINS=1 # qt debug模式，显示更多报错信息

# PATH
export PATH="$GOBIN:$HOME/.local/bin:$PATH"

# huggingface
export HF_ENDPOINT=https://hf-mirror.com # huggingface 镜像

# macos
if [[ "$(uname)" == "Darwin" ]]; then
    # homebrew
    export HOMEBREW_PIP_INDEX_URL=http://mirrors.aliyun.com/pypi/simple #ckbrew
    export HOMEBREW_API_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles/api  #ckbrew
    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles #ckbrew
    eval $(/opt/homebrew/bin/brew shellenv) #ckbrew
    export HOMEBREW_NO_INSTALL_FROM_API=1 # 走本地homebrew/cask
fi
