#!/bin/bash

# parse gdbserver options (must be converted to LinkServer command options)
while [[ $# -gt 0 ]]; do
  case $1 in
    -c*)
      eval cargs="($2)"
      case $cargs[0] in
        gdb_port*)
          gdbport=${cargs[1]}
          ;;
        telnet_port*)
          telnetport=${cargs[1]}
          ;;
        *)
          echo "unsupported: \"$1 $2\""
          ;;
      esac
      ;;
    -f*)
      echo "unsupported: \"$1 $2\""
      ;;
    -device*)
      device=$2
      ;;
    *)
      echo "unsupported: \"$1 $2\""
      ;;
  esac
  shift 2
done

# forward to NXP LinkServer
/usr/local/LinkServer/LinkServer gdbserver --gdb-port $gdbport --semihost-port $telnetport --update-mode auto $device
