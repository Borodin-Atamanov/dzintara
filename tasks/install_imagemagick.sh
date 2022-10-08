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

install_system build-essential

download_url='https://github.com/ImageMagick/ImageMagick.git'

#temp_file="/tmp/archive.tar.gz"
temp_dir="$(mktemp)"
app_install_dir="/usr/local/bin/"
#rm -v "$temp_file"
#wget --output-document="$temp_file" --retry-on-host-error --no-check-certificate "$download_url"
echo "clone config from github";
cd "${temp_dir}";
git clone --verbose --progress --depth 1 "${firefox_config_github_url}" "${temp_dir}";

if ! [[ -s "$temp_file" ]] ; then
  echo "Fatal error! Config file ${temp_file} not exists after download"
  exit_code=1
  exit
else
  time ./configure
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



exit

# https://mkvtoolnix.download/downloads.html
mkvtoolnix_list_file='/etc/apt/sources.list.d/mkvtoolnix.list';
mkvtoolnix_key_file='/usr/share/keyrings/gpg-pub-moritzbunkus.gpg';

wget -qO- https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg  | gpg --dearmor | tee "$mkvtoolnix_key_file" | base32 | wc

mkvtoolnix_list_file_content=$(cat <<_ENDOFFILE
deb [signed-by=${mkvtoolnix_key_file}] https://mkvtoolnix.download/debian/ ${os_codename} main
_ENDOFFILE
)
echo -e "$mkvtoolnix_list_file_content" > "${mkvtoolnix_list_file}"

install_system apt-transport-https
install_system update
install_system mkvtoolnix
install_system mkvtoolnix-gui

exit
