# dotfiles for CentOS

## from scratch

1. Install [dependencies for Homebrew on CentOS](https://docs.brew.sh/Homebrew-on-Linux).

    ```bash
    sudo yum groupinstall 'Development Tools'
    sudo yum install procps-ng curl file git
    ```

2. Run the bootstrap script of this repository.

    ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/umemotsu/dotfiles-centos/main/script/bootstrap.sh)"
    ```
