## 安装步骤

1. 依赖安装
  - 快速查找 fd: <https://github.com/sharkdp/fd>
  - 快速跳转目录 zoxide: <https://github.com/ajeetdsouza/zoxide>
  - 终端文件管理器 yazi: <https://github.com/sxyazi/yazi>
  - 模糊搜索 fzf: <https://github.com/junegunn/fzf>
  - prompt主题 starship: <https://github.com/starship/starship>
  - 历史命令同步 atuin: <https://github.com/atuinsh/atuin>
  - 终端程序 ghostty: <https://github.com/ghostty-org/ghostty>
  - 插件管理 zinit: <https://github.com/zdharma-continuum/zinit>
  - 安装 trash
  - 安装 zsh

1. 克隆仓库

    ```bash
    # 克隆本仓库
    git clone https://github.com/wuqin0202/dotfiles.git
    cd dotfiles
    ```

2. 开始安装

    ```bash
    chsh -s $(which zsh)
    ./install.sh
    ```

## 注意

1. 先把 `$HOME/.conda/envs` 下的虚拟环境迁移到 `$HOME/.local/share/conda/envs`