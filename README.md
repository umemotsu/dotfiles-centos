# dotfiles

## from scratch

1. Complete OS-specific configuration via `System Preferences` manually (not automated as of now).

  - Apple ID
  - Network
  - ...

2. Install the command line developer tools.

  ```bash
  xcode-select --install
  ```

3. Run the bootstrap script of this repository.

  ```bash
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/umemotsu/dotfiles/master/script/bootstrap.sh)"
  ```
