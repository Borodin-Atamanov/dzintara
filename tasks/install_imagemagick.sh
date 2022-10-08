#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install tor

#source "${work_dir}tasks/1.sh"
#get info about OS

os_codename=$( trim $(lsb_release --short --codename ))
#lsb_release --short --id --codename --description --release = Ubuntu Ubuntu 22.04.1 LTS  22.04 jammy | Debian Debian GNU/Linux 11 (bullseye) 11 bullseye
architecture=$( trim $(dpkg --print-architecture))
#It should output either amd64, arm64, or i386
show_var os_codename
show_var architecture

# https://imagemagick.org/script/security-policy.php
write_config "usr:local:etc:ImageMagick-7:policy.xml"

if [ -f "/usr/local/bin/magick" ]; then
  echo "app already exists in system. Exit"
  exit 0
fi

install_system build-essential

download_url='https://github.com/ImageMagick/ImageMagick.git'

#temp_file="/tmp/archive.tar.gz"
temp_dir="$(mktemp -d -t dzintara-XXXXX)"
app_install_dir="/usr/local/bin/"
#rm -v "$temp_file"
#wget --output-document="$temp_file" --retry-on-host-error --no-check-certificate "$download_url"
echo "clone from github";
cd "${temp_dir}";
git clone --verbose --progress --depth 1 "${download_url}" "${temp_dir}";
exit_code=$?

if $exit_code ; then
  echo "error! exit_code after git clone is $exit_code "
  exit $exit_code
else
  ./configure
  make
  ./configure --with-modules
  make install
  ldconfig /usr/local/lib
  make check
  # extract tar to temp directory
  # rm -rvf "$temp_dir"
  # mkdir -pv "$temp_dir"
  # cd "$temp_dir"
  # tar -xvf "$temp_file" --directory "$temp_dir"
  # rsync --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --ignore-errors --max-delete=0 --exclude='.git' --exclude='.git*' --human-readable --stats --itemize-changes "${temp_dir}/" "${cursors_install_dir}/"
  #  | tr -d '\n'
fi
