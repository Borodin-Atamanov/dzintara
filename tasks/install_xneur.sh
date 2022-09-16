#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
# install task script

install_system xneur

# TODO change some values in config
#change config
config_file='/etc/xneur/xneurrc';
load_var_from_file "$config_file" config_var
replace_line_by_string config "ManualMode " "ManualMode Yes" "#"
replace_line_by_string config "DefaultXkbGroup 0 " "# DefaultXkbGroup 0" ""
replace_line_by_string config "AddBind ChangecaseSelected Shift Alt Break " "# AddBind ChangecaseSelected Shift Alt Break" ""
replace_line_by_string config "AddBind PreviewChangeSelected Enable Preview selected text correction" "# AddBind PreviewChangeSelected Enable Preview selected text correction" ""
replace_line_by_string config "AddBind ChangeClipboard Control Scroll_Lock" "ManualMode Yes" "#"
replace_line_by_string config "AddBind ReplaceAbbreviation Shift Tab" "#AddBind ReplaceAbbreviation Shift Tab" ""
replace_line_by_string config "AddBind AutocompletionConfirmation Tab" "#AddBind AutocompletionConfirmation Tab" ""
replace_line_by_string config "AddBind RotateAutocompletion Control Tab" "#AddBind RotateAutocompletion Control Tab" ""
replace_line_by_string config "SoundVolumePercent" "SoundVolumePercent 15" "#"
replace_line_by_string config "SendDelay" "SendDelay 11" "#"
replace_line_by_string config "LogSize" "LogSize 2147483000" "#"
replace_line_by_string config "LogSave" "LogSave Yes" "#"
replace_line_by_string config "ShowPopup" "ShowPopup No" "#"
replace_line_by_string config "CheckOnProcess" "CheckOnProcess No" "#"
replace_line_by_string config "DisableCapsLock" "DisableCapsLock Yes" "#"
replace_line_by_string config "Autocompletion" "Autocompletion No" "#"
replace_line_by_string config "# All values writted XNeur" "# This file edited automagicaly by Dzintara ${x0a}${x0a}${x0a}${x0a}${x0a} # xneur is cool, yeah!" ""
save_var_to_file "$config_file" config_var

#cp -v "$config_file"

# TODO copy root config and user config

