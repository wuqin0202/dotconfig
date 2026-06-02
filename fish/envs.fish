# ============================ XDG Base Directory ============================
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# ============================ Default Programs ============================
set -gx EDITOR nvim

# ============================ Go ============================
set -gx GOPATH $XDG_DATA_HOME/go
set -gx GOBIN $GOPATH/bin

# ============================ Java ============================
set -gx _JAVA_OPTIONS -Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# ============================ GnuPG ============================
set -gx GNUPGHOME $XDG_DATA_HOME/gnupg

# ============================ Rust ============================
set -gx CARGO_HOME $XDG_DATA_HOME/cargo

# ============================ Gradle ============================
set -gx GRADLE_USER_HOME $XDG_DATA_HOME/gradle

# ============================ npm ============================
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npm.conf

# ============================ CUDA ============================
if command -v nvidia-smi >/dev/null 2>&1
    set -gx CUDA_CACHE_PATH $XDG_CACHE_HOME/nv
    set -gx CUDA_PATH /usr/local/cuda
    set -gx CUDA_HOME /usr/local/cuda
    set -gx CUDNN_PATH /usr/local/cuda/include
    set -gx PATH /usr/local/cuda/bin $PATH
    set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH
end

# ============================ Python ============================
set -gx PYTHONPYCACHEPREFIX $XDG_CACHE_HOME/python
set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/startup.py
set -gx PYTHONHISTFILE $XDG_STATE_HOME/python/history
set -gx IPYTHONDIR $XDG_STATE_HOME/python/ipython
set -gx MPLCONFIGDIR $XDG_CONFIG_HOME/matplotlib

# ============================ Jupyter ============================
set -gx JUPYTER_CONFIG_DIR $XDG_CONFIG_HOME/jupyter
set -gx JUPYTER_DATA_DIR $XDG_DATA_HOME/jupyter
if set -q XDG_RUNTIME_DIR
    set -gx JUPYTER_RUNTIME_DIR $XDG_RUNTIME_DIR/jupyter
else
    set -gx JUPYTER_RUNTIME_DIR $TMPDIR/jupyter
end

# ============================ Less ============================
set -gx LESSHISTFILE $XDG_STATE_HOME/less/history
set -gx LESSKEYIN $XDG_CONFIG_HOME/lesskey

# ============================ TensorFlow / Keras ============================
set -gx KERAS_HOME $XDG_CACHE_HOME/keras

# ============================ MySQL ============================
set -gx MYSQL_HISTFILE $XDG_DATA_HOME/mysql_history

# ============================ Atuin ============================
set -gx ATUIN_DB_PATH $XDG_DATA_HOME/atuin/fish-history.db

# ============================ Wget ============================
set -gx WGETRC $XDG_CONFIG_HOME/wget/wgetrc

# ============================ PATH ============================
set -gx PATH $GOBIN $HOME/.local/bin $PATH

# ============================ Hugging Face ============================
set -gx HF_ENDPOINT https://hf-mirror.com

# ============================ macOS ============================
if test (uname) = Darwin
    # Homebrew mirrors
    set -gx HOMEBREW_PIP_INDEX_URL http://mirrors.aliyun.com/pypi/simple
    set -gx HOMEBREW_API_DOMAIN https://mirrors.aliyun.com/homebrew/homebrew-bottles/api
    set -gx HOMEBREW_BOTTLE_DOMAIN https://mirrors.aliyun.com/homebrew/homebrew-bottles
    /opt/homebrew/bin/brew shellenv | source
    set -gx HOMEBREW_NO_INSTALL_FROM_API 1
end
