#!/usr/bin/env bash

MYTERMUX_DIR="$(cd "$(dirname "$0")" && pwd)"

HELPERS=(
  colors animation banner package switchcase cleanup
  dotfiles clone themes nvchad utility
  stat signal screen cursor finish
)

for HELPER in ${HELPERS[@]}; do
  source $(pwd)/helper/${HELPER}.sh
done

function main() {

  trap 'handleInterruptByUser "Interrupt by User"' 2

  clear
  banner

  packages
  switchCase "Install" "Core Packages" \
    "Essential development and file management tools bat, clang, neovim, and more." \
    installPackages "" required

  dotFiles
  switchCase "Install" "Dotfiles" \
    "Pre-configured shell aliases, themes, fonts, and scripts with automatic backups." \
    installDotFilesWithBackup "" required

  switchCase "Install" "Music Player" \
    "Background MPD daemon, NCMPCPP visualizer, and 'music' CLI player." \
    installMusic cleanupMusic

  switchCase "Install" "Terminal Color Toys" \
    "Animated terminal visualizers pipes, matrix rains, pacman, and more." \
    "true" cleanupToys

  switchCase "Install" "Extra CLI Tools" \
    "Productivity shortcuts for media downloading (ytdl/dlv with ffmpeg & yt-dlp), SSH keys, and network info." \
    installExtraTools cleanupExtraTools

  repositories
  switchCase "Clone" "Repositories" \
    "Oh-My-Zsh framework, syntax highlighting, autosuggestions, and tmux themes." \
    cloneRepository "" required

  zshTheme
  switchCase "Install" "ZSH Themes" \
    "12 prompt themes with git indicators, directory paths, and custom styling." \
    installZshTheme

  switchCase "Install" "NvChad" \
    "Modern Neovim IDE configuration with file tree, syntax highlighting, and LSP." \
    NvChad cleanupNvChad

  switchCase "Apply" "Utility Settings" \
    "JetBrains Mono Nerd Font, automatic ZSH shell login, and motd cleanup." \
    utility "" required

  promptCustomUser
  removeInstallerFolder
  mainAlert

}

function promptCustomUser() {

  echo ""
  stat "INFO" "Info" "Themes like ma, powerline and status show 'user@host' in the prompt."
  echo ""

  while :; do
    read -p "    Set a custom prompt username (e.g. Neo)? [Y/n] " ANSWER

    case "$ANSWER" in
      n | N )
        stat "INFO" "Warning" "Keeping the auto-detected username."
        break
      ;;
      y | Y )
        echo ""
        while :; do
          read -p "    Username: " USERNAME
          if [[ -z "${USERNAME}" ]]; then
            stat "ERROR" "Warning" "Username can't be empty — type a name to continue."
            echo ""
            continue
          fi
          USERNAME="${USERNAME//%/}"
          mkdir -p "${HOME}/.config/mytermux"
          echo -n "${USERNAME}" > "${HOME}/.config/mytermux/user.log"
          stat "RESULT" "Success" "Username set to '${USERNAME}'. It will show in the prompt on the next shell."
          break
        done
        break
      ;;
      "" )
        echo ""
        stat "INFO" "Warning" "No answer given — type 'y' to set a username or 'n' to keep default."
        echo ""
      ;;
      * )
        echo ""
        stat "ERROR" "Warning" "Unknown '${ANSWER}' — type 'y' or 'n'."
        echo ""
      ;;
    esac
  done

}

function removeInstallerFolder() {

  echo ""
  stat "INFO" "Info" "The installation is complete. The cloned myTermux folder is no longer needed."
  echo ""

  if [[ "${MYTERMUX_DIR}" == "${HOME}" || "${MYTERMUX_DIR}" == "/" ]]; then
    stat "ERROR" "Warning" "Refusing to remove '${MYTERMUX_DIR}'. Delete it manually."
    return 0
  fi

  while :; do
    read -r -p "    Remove the cloned myTermux folder '${MYTERMUX_DIR}'? [y/N] " ANSWER

    case "$ANSWER" in
      y | Y )
        echo ""
        read -r -p "    This permanently deletes '${MYTERMUX_DIR}'. Type 'y' to confirm: " CONFIRM
        case "$CONFIRM" in
          y | Y )
            stat "RUN" "Warning" "Removing the myTermux folder..."
            cd "${HOME}" 2> /dev/null
            rm -rf -- "${MYTERMUX_DIR}"
            stat "RESULT" "Success" "myTermux folder removed."
            break
          ;;
          n | N | "" )
            stat "INFO" "Warning" "Keeping the myTermux folder."
            break
          ;;
          * )
            stat "ERROR" "Warning" "Unknown '${CONFIRM}'. Type 'y' to delete or 'n' to keep it."
            echo ""
          ;;
        esac
      ;;
      n | N | "" )
        stat "INFO" "Warning" "Keeping the myTermux folder."
        break
      ;;
      * )
        stat "ERROR" "Warning" "Unknown '${ANSWER}'. Type 'y' to delete or 'n' to keep it."
        echo ""
      ;;
    esac
  done

  echo ""

}

screenSize main