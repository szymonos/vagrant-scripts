#!/usr/bin/env bash
: '
#
sudo .assets/provision/install_fonts_cascadiacode.sh >/dev/null
'
if [ $EUID -ne 0 ]; then
  printf '\e[31;1mRun the script as root.\e[0m\n'
  exit 1
fi

# variables
REL=$1
TMP_DIR=$(mktemp -dp "$PWD")

# get latest release if not provided as a parameter
while [ -z "$REL" ]; do
  REL=$(curl -sk https://api.github.com/repos/microsoft/cascadia-code/releases/latest | sed -En 's/.*"tag_name": "v?([^"]*)".*/\1/p')
  ((retry_count++))
  if [ $retry_count -eq 10 ]; then
    printf "\e[33m$APP version couldn't be retrieved\e[0m\n" >&2
    exit 0
  fi
  [ -n "$REL" ] || echo 'retrying...' >&2
done
# return latest release
echo $REL

echo "Install CascadiaCode v$REL" >&2
retry_count=0
while [[ ! -f CascadiaCode.zip && $retry_count -lt 10 ]]; do
  curl -Lsk -o "$TMP_DIR/CascadiaCode.zip" "https://github.com/microsoft/cascadia-code/releases/download/v${REL}/CascadiaCode-${REL}.zip"
  ((retry_count++))
done
unzip -q "$TMP_DIR/CascadiaCode.zip" -d "$TMP_DIR"
mkdir -p /usr/share/fonts/cascadia-code
find "$TMP_DIR/ttf" -type f -name "*.ttf" -exec cp {} /usr/share/fonts/cascadia-code/ \;
rm -fr "$TMP_DIR"
# build font information caches
fc-cache -f /usr/share/fonts/cascadia-code/
