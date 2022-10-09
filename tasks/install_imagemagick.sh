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
write_config "usr:local:etc:ImageMagick-7:policy.xml" '/usr/local/etc/ImageMagick-6/policy.xml'

# https://askubuntu.com/questions/1042436/how-to-install-delegate-libraries-for-image-magick-7-0-7


if [ -f "/usr/local/bin/magick" ]; then
  echo "app already exists in system. Exit"
  exit 0
fi



app_install_dir="/usr/local/bin/"

# TODO if x86_64 download AppImage https://imagemagick.org/archive/binaries/magick

if [[ "$architecture" == 'amd64' ]]; then
  # download appimage
  download_url='https://imagemagick.org/archive/binaries/magick'
  wget --output-document="${app_install_dir}/magick" --retry-on-host-error --no-check-certificate "$download_url" | cat
  chmod -v 0444 "${app_install_dir}/magick"
  # chown  --changes --recursive  root:root  "${app_install_dir}/magick"
else
  # download from repository (outdated version)
  install_system imagemagick
fi;

# compile from source code
install_system build-essential

download_url='https://github.com/ImageMagick/ImageMagick.git'

#temp_file="/tmp/archive.tar.gz"
temp_dir="$(mktemp -d -t dzintara-XXXXX)"

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
  # https://imagemagick.org/script/advanced-linux-installation.php
  # https://askubuntu.com/questions/1042436/how-to-install-delegate-libraries-for-image-magick-7-0-7
  apt-get build-dep imagemagick
  ./configure
  make -j 4
  ./configure --with-modules
  make install
  ldconfig /usr/local/lib
  make check
  # BUG: after this compilation imagemagick can not read simpe png file (it needs delegates for every file format)

  # extract tar to temp directory
  # rm -rvf "$temp_dir"
  # mkdir -pv "$temp_dir"
  # cd "$temp_dir"
  # tar -xvf "$temp_file" --directory "$temp_dir"
  # rsync --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --ignore-errors --max-delete=0 --exclude='.git' --exclude='.git*' --human-readable --stats --itemize-changes "${temp_dir}/" "${cursors_install_dir}/"
  #  | tr -d '\n'
fi
