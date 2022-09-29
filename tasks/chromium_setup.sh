#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT

install_system chromium-browser
install_system rsync
install_system git

temp_dir="${TMPDIR:-/tmp}/dzintara_chromium_dir-$(date "+%F-%H-%M-%S")";
mkdir -pv "${temp_dir}";
echo "clone config from github";
slog "<7>$(show_var work_dir)";
git clone --verbose --progress --depth 1 "${chromium_config_github_url}" "${temp_dir}";
cd "${temp_dir}";

rsync --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --delete-after --ignore-errors --exclude='.git' --exclude='.git*' --human-readable  --info=progress2 --progress --stats --itemize-changes "${temp_dir}/" "${chromium_config_dir}/"  | tr -d '\n'

exit
