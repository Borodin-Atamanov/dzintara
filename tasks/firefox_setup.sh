#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT

install_system chromium-browser
install_system rsync
install_system git


if [ -f "${chromium_config_dir}/dont_overwrite_config.flag" ]; then
  echo "${chromium_config_dir}/dont_overwrite_config.flag exists! So don't overwrite configuration."
  exit 0
fi

temp_dir="${TMPDIR:-/tmp}/dzintara_chromium_dir-$(date "+%F-%H-%M-%S")";
mkdir -pv "${temp_dir}";
echo "clone config from github";
slog "<7>$(show_var work_dir)";
git clone --depth 1 "${chromium_config_github_url}" "${temp_dir}";
cd "${temp_dir}";

rsync --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --delete-after --ignore-errors --exclude='.git' --exclude='.git*' --human-readable --stats --itemize-changes "${temp_dir}/" "${chromium_config_dir}/"  | tr -d '\n'

echo 'this file created by Dzintara chromium_setup.sh' > "${chromium_config_dir}/dont_overwrite_config.flag";
find "${chromium_config_dir}/" -type d -exec chmod -v 0777 {} \;
find "${chromium_config_dir}/" -type f -exec chmod -v 0640 {} \;
chown  --changes --recursive  i:i "${chromium_config_dir}";

exit
