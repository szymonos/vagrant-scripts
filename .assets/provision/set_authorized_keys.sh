#!/bin/bash
# check if the passed parameter starts with rsa phrase
if ! echo "$1" | grep -E '^(ssh-|ecdsa-)' &>/dev/null; then
  echo -e '\e[91mMissing ssh public key in the script parameter!'
  exit 1
fi

grep "$1" ~/.ssh/authorized_keys &>/dev/null || echo "$1" >>~/.ssh/authorized_keys
