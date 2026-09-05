#!/usr/bin/env bash

function NvChad() {

  echo -e "\n    📦 Installing NvChad (Modern Neovim Setup)\n"

  stat "RUN" "Warning" "Cleaning old Neovim files..."
  rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim

  stat "RUN" "Warning" "Cloning starter template..."

  if git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1 &> /dev/null; then

    stat "RESULT" "Success" "NvChad successfully installed to .config/nvim"

    NVIM_LOG="${HOME}/.config/nvim/.lazy-install.log"
    mkdir -p "${HOME}/.config/nvim"

    start_animation "    Installing NvChad plugins ..."

    if nvim --headless "+Lazy! sync" +qa > "${NVIM_LOG}" 2>&1; then

      stop_animation 0
      rm -f "${NVIM_LOG}"

    else

      stop_animation 1
      stat "INFO" "Warning" "Plugin sync failed - last lines of the log:"
      tail -n 15 "${NVIM_LOG}" | sed 's/^/    /'
      rm -f "${NVIM_LOG}"

    fi

  else

    stat "RESULT" "Danger" "NvChad installation failed."

  fi

}
