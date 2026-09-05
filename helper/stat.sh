#!/usr/bin/env bash

function stat() {

  case "${2}" in

    "Info" )
      echo -e "    [ ${COLOR_SKY}${1}${COLOR_BASED} ] > ${3}"
    ;;

    "Success" )
      echo -e "    [ ${COLOR_SUCCESS}${1}${COLOR_BASED} ] > ${3}"
    ;;

    "Warning" )
      echo -e "    [ ${COLOR_WARNING}${1}${COLOR_BASED} ] > ${3}"
    ;;

    "Danger" )
      echo -e "    [ ${COLOR_DANGER}${1}${COLOR_BASED} ] > ${3}"
    ;;

    * )
      echo -e "    [ ${COLOR_BASED}${1}${COLOR_BASED} ] > ${3}"
    ;;

  esac

}
