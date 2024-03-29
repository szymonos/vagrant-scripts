#!/usr/bin/env bash
: '
sudo .assets/provision/install_minikube.sh >/dev/null
'
if [ $EUID -ne 0 ]; then
  printf '\e[31;1mRun the script as root.\e[0m\n'
  exit 1
fi

# determine system id
SYS_ID="$(sed -En '/^ID.*(alpine|arch|fedora|debian|ubuntu|opensuse).*/{s//\1/;p;q}' /etc/os-release)"
# check if package installed already using package manager
APP='minikube'
case $SYS_ID in
alpine)
  exit 0
  ;;
arch)
  pacman -Qqe $APP &>/dev/null && exit 0 || true
  ;;
esac

REL=$1
retry_count=0
# try 10 times to get latest release if not provided as a parameter
while [ -z "$REL" ]; do
  REL=$(curl -sk https://api.github.com/repos/kubernetes/minikube/releases/latest | sed -En 's/.*"tag_name": "v?([^"]*)".*/\1/p')
  ((retry_count++))
  if [ $retry_count -eq 10 ]; then
    printf "\e[33m$APP version couldn't be retrieved\e[0m\n" >&2
    exit 0
  fi
  [ -n "$REL" ] || echo 'retrying...' >&2
done
# return latest release
echo $REL

if type $APP &>/dev/null; then
  VER=$(minikube version | grep -Po '(?<=v)[0-9\.]+$')
  if [ "$REL" = "$VER" ]; then
    printf "\e[32m$APP v$VER is already latest\e[0m\n" >&2
    exit 0
  fi
fi

printf "\e[92minstalling \e[1m$APP\e[22m v$REL\e[0m\n" >&2
case $SYS_ID in
arch)
  pacman -Sy --needed --noconfirm minikube >&2 2>/dev/null || binary=true
  ;;
fedora)
  dnf install -y "https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm" >&2 2>/dev/null || binary=true
  ;;
debian | ubuntu)
  export DEBIAN_FRONTEND=noninteractive
  retry_count=0
  while [[ ! -f minikube_latest_amd64.deb && $retry_count -lt 10 ]]; do
    curl -LOsk "https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb"
    ((retry_count++))
  done
  dpkg -i minikube_latest_amd64.deb >&2 2>/dev/null && rm -f minikube_latest_amd64.deb || binary=true
  ;;
opensuse)
  zypper in -y --allow-unsigned-rpm "https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm" >&2 2>/dev/null || binary=true
  ;;
*)
  binary=true
  ;;
esac

if [ "$binary" = true ]; then
  echo 'Installing from binary.' >&2
  retry_count=0
  while [[ ! -f minikube-linux-amd64 && $retry_count -lt 10 ]]; do
    curl -LOsk "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
    ((retry_count++))
  done
  install -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
fi
