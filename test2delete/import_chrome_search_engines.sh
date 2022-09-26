#!/usr/bin/bash
if ps -x | grep -v grep | grep Google\ Chrome > /dev/null; then
    echo "Close Chrome and try again..."
    exit 1
fi

SOURCE=${1:-./keywords.sql}
#SOURCE=$1
TEMP_SQL_SCRIPT=/tmp/sync_chrome_sql_script
echo
echo "Importing Chrome keywords from $SOURCE..."
cd ~/.config/google-chrome/Default
echo DROP TABLE IF EXISTS keywords\; > $TEMP_SQL_SCRIPT
echo .read $SOURCE >> $TEMP_SQL_SCRIPT
sqlite3 -init $TEMP_SQL_SCRIPT Web\ Data .exit
rm $TEMP_SQL_SCRIPT
