#!/usr/bin/env bash

function handleInterruptByUser() {

  echo -e "\n    [ ${COLOR_WARNING}WARNING${COLOR_BASED} ] > ${COLOR_DANGER}Action aborted by user.${COLOR_BASED}\n"

  setCursor on

  exit 1

}