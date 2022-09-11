#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
source "${work_dir}tasks/1.sh"
source "/home/i/bin/dzintara/autorun/load_variables.sh"

cvt_xrandr 1920 1080 60
cvt_xrandr 1360 768 60
cvt_xrandr 1280 1024 60

if [ is_root ]; then
    #run only from root
    install_system autorandr
fi

autorandr --debug  --force --save "itworks"
autorandr --debug --force --default "itworks"

if [ is_root ]; then
    #run only from root
    su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; autorandr --debug --force --save itworks "
    su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; autorandr --debug --force --default itworks "
    #su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; autorandr --debug --change "
    autorandr
fi

xrandr
autorandr --debug --config

# cvt_xrandr 160 200 30
# cvt_xrandr 256 192 30
# cvt_xrandr 320 200 30
# cvt_xrandr 320 240 30
# cvt_xrandr 320 256 30
# cvt_xrandr 320 240 30
# cvt_xrandr 320 480 30
# cvt_xrandr 352 240 30
# cvt_xrandr 352 288 30
# cvt_xrandr 400 240 30
# cvt_xrandr 400 288 30
# cvt_xrandr 400 240 30
# cvt_xrandr 480 272 30
# cvt_xrandr 480 320 30
# cvt_xrandr 480 576 30
# cvt_xrandr 512 256 30
# cvt_xrandr 512 342 30
# cvt_xrandr 512 384 30
# cvt_xrandr 640 200 30
# cvt_xrandr 640 256 30
# cvt_xrandr 640 256 30
# cvt_xrandr 640 272 30
# cvt_xrandr 640 288 30
# cvt_xrandr 640 350 30
# cvt_xrandr 640 400 30
# cvt_xrandr 640 480 30
# cvt_xrandr 640 512 30
# cvt_xrandr 640 240 30
# cvt_xrandr 640 360 30
# cvt_xrandr 640 480 30
# cvt_xrandr 720 348 30
# cvt_xrandr 720 350 30
# cvt_xrandr 720 360 30
# cvt_xrandr 720 480 30
# cvt_xrandr 720 576 30
# cvt_xrandr 784 640 30
# cvt_xrandr 800 480 30
# cvt_xrandr 800 600 30
# cvt_xrandr 800 480 30
# cvt_xrandr 800 600 30
# cvt_xrandr 848 480 30
# cvt_xrandr 854 466 30
# cvt_xrandr 854 480 30
# cvt_xrandr 960 540 30
# cvt_xrandr 960 640 30
# cvt_xrandr 960 540 30
# cvt_xrandr 1024 576 30
# cvt_xrandr 1024 600 30
# cvt_xrandr 1024 768 30
# cvt_xrandr 1024 600 30
# cvt_xrandr 1024 768 30
# cvt_xrandr 1120 832 30
# cvt_xrandr 1152 864 30
# cvt_xrandr 1152 900 30
# cvt_xrandr 1152 864 30
# cvt_xrandr 1200 600 30
# cvt_xrandr 1280 720 30
# cvt_xrandr 1280 768 30
# cvt_xrandr 1280 800 30
# cvt_xrandr 1280 854 30
# cvt_xrandr 1280 960 30
# cvt_xrandr 1280 1024 30
# cvt_xrandr 1280 720 30
# cvt_xrandr 1280 768 30
# cvt_xrandr 1280 1024 30
# cvt_xrandr 1366 768 30
# cvt_xrandr 1400 1050 30
# cvt_xrandr 1400 1050 30
# cvt_xrandr 1440 900 30
# cvt_xrandr 1440 1080 30
# cvt_xrandr 1440 900 30
# cvt_xrandr 1536 960 30
# cvt_xrandr 1536 1024 30
# cvt_xrandr 1600 768 30
# cvt_xrandr 1600 750 30
# cvt_xrandr 1600 900 30
# cvt_xrandr 1600 1024 30
# cvt_xrandr 1600 1200 30
# cvt_xrandr 1600 900 30
# cvt_xrandr 1600 1024 30
# cvt_xrandr 1600 1200 30
# cvt_xrandr 1680 1050 30
# cvt_xrandr 1680 1050 30
# cvt_xrandr 1920 1080 30
# cvt_xrandr 1920 1200 30
# cvt_xrandr 1920 1080 30
# cvt_xrandr 1920 1200 30
# cvt_xrandr 2048 1152 30
# cvt_xrandr 2048 1536 30
# cvt_xrandr 2048 1080 30
# cvt_xrandr 2048 1152 30
# cvt_xrandr 2048 1536 30
# cvt_xrandr 2560 1440 30
# cvt_xrandr 2560 1600 30
# cvt_xrandr 2560 2048 30
# cvt_xrandr 2560 1440 30
# cvt_xrandr 2560 1600 30
# cvt_xrandr 2560 2048 30
# cvt_xrandr 2880 1800 30
# cvt_xrandr 3072 1620 30
# cvt_xrandr 3200 2048 30
# cvt_xrandr 3200 2400 30
# cvt_xrandr 3200 1800 30
# cvt_xrandr 3200 2048 30
# cvt_xrandr 3200 2400 30
# cvt_xrandr 3280 2048 30
# cvt_xrandr 3440 1440 30
# cvt_xrandr 3840 2160 30
# cvt_xrandr 3840 2400 30
# cvt_xrandr 3840 2400 30
# cvt_xrandr 3840 2160 30
# cvt_xrandr 4096 2160 30
# cvt_xrandr 4096 2160 30
# cvt_xrandr 5120 1440 30
# cvt_xrandr 5120 2160 30
# cvt_xrandr 5120 2700 30
# cvt_xrandr 5120 2880 30
# cvt_xrandr 5120 3840 30
# cvt_xrandr 5120 4096 30
# cvt_xrandr 5120 1440 30
# cvt_xrandr 5120 2700 30
# cvt_xrandr 5120 4096 30
# cvt_xrandr 6144 3240 30
# cvt_xrandr 6400 4096 30
# cvt_xrandr 6400 4800 30
# cvt_xrandr 6400 4096 30
# cvt_xrandr 6400 4800 30
# cvt_xrandr 7168 3780 30
# cvt_xrandr 7680 4320 30
# cvt_xrandr 7680 4800 30
# cvt_xrandr 7680 4320 30
# cvt_xrandr 7680 4800 30
# cvt_xrandr 8192 4320 30
# cvt_xrandr 8192 4320 30
# cvt_xrandr 160 200 60
# cvt_xrandr 256 192 60
# cvt_xrandr 320 200 60
# cvt_xrandr 320 240 60
# cvt_xrandr 320 256 60
# cvt_xrandr 320 240 60
# cvt_xrandr 320 480 60
# cvt_xrandr 352 240 60
# cvt_xrandr 352 288 60
# cvt_xrandr 400 240 60
# cvt_xrandr 400 288 60
# cvt_xrandr 400 240 60
# cvt_xrandr 480 272 60
# cvt_xrandr 480 320 60
# cvt_xrandr 480 576 60
# cvt_xrandr 512 256 60
# cvt_xrandr 512 342 60
# cvt_xrandr 512 384 60
# cvt_xrandr 640 200 60
# cvt_xrandr 640 256 60
# cvt_xrandr 640 256 60
# cvt_xrandr 640 272 60
# cvt_xrandr 640 288 60
# cvt_xrandr 640 350 60
# cvt_xrandr 640 400 60
# cvt_xrandr 640 480 60
# cvt_xrandr 640 512 60
# cvt_xrandr 640 240 60
# cvt_xrandr 640 360 60
# cvt_xrandr 640 480 60
# cvt_xrandr 720 348 60
# cvt_xrandr 720 350 60
# cvt_xrandr 720 360 60
# cvt_xrandr 720 480 60
# cvt_xrandr 720 576 60
# cvt_xrandr 784 640 60
# cvt_xrandr 800 480 60
# cvt_xrandr 800 600 60
# cvt_xrandr 800 480 60
# cvt_xrandr 800 600 60
# cvt_xrandr 848 480 60
# cvt_xrandr 854 466 60
# cvt_xrandr 854 480 60
# cvt_xrandr 960 540 60
# cvt_xrandr 960 640 60
# cvt_xrandr 960 540 60
# cvt_xrandr 1024 576 60
# cvt_xrandr 1024 600 60
# cvt_xrandr 1024 768 60
# cvt_xrandr 1024 600 60
# cvt_xrandr 1024 768 60
# cvt_xrandr 1120 832 60
# cvt_xrandr 1152 864 60
# cvt_xrandr 1152 900 60
# cvt_xrandr 1152 864 60
# cvt_xrandr 1200 600 60
# cvt_xrandr 1280 720 60
# cvt_xrandr 1280 768 60
# cvt_xrandr 1280 800 60
# cvt_xrandr 1280 854 60
# cvt_xrandr 1280 960 60
# cvt_xrandr 1280 1024 60
# cvt_xrandr 1280 720 60
# cvt_xrandr 1280 768 60
# cvt_xrandr 1280 1024 60
# cvt_xrandr 1366 768 60
# cvt_xrandr 1400 1050 60
# cvt_xrandr 1400 1050 60
# cvt_xrandr 1440 900 60
# cvt_xrandr 1440 1080 60
# cvt_xrandr 1440 900 60
# cvt_xrandr 1536 960 60
# cvt_xrandr 1536 1024 60
# cvt_xrandr 1600 768 60
# cvt_xrandr 1600 750 60
# cvt_xrandr 1600 900 60
# cvt_xrandr 1600 1024 60
# cvt_xrandr 1600 1200 60
# cvt_xrandr 1600 900 60
# cvt_xrandr 1600 1024 60
# cvt_xrandr 1600 1200 60
# cvt_xrandr 1680 1050 60
# cvt_xrandr 1680 1050 60
# cvt_xrandr 1920 1080 60
# cvt_xrandr 1920 1200 60
# cvt_xrandr 1920 1080 60
# cvt_xrandr 1920 1200 60
# cvt_xrandr 2048 1152 60
# cvt_xrandr 2048 1536 60
# cvt_xrandr 2048 1080 60
# cvt_xrandr 2048 1152 60
# cvt_xrandr 2048 1536 60
# cvt_xrandr 2560 1440 60
# cvt_xrandr 2560 1600 60
# cvt_xrandr 2560 2048 60
# cvt_xrandr 2560 1440 60
# cvt_xrandr 2560 1600 60
# cvt_xrandr 2560 2048 60
# cvt_xrandr 2880 1800 60
# cvt_xrandr 3072 1620 60
# cvt_xrandr 3200 2048 60
# cvt_xrandr 3200 2400 60
# cvt_xrandr 3200 1800 60
# cvt_xrandr 3200 2048 60
# cvt_xrandr 3200 2400 60
# cvt_xrandr 3280 2048 60
# cvt_xrandr 3440 1440 60
# cvt_xrandr 3840 2160 60
# cvt_xrandr 3840 2400 60
# cvt_xrandr 3840 2400 60
# cvt_xrandr 3840 2160 60
# cvt_xrandr 4096 2160 60
# cvt_xrandr 4096 2160 60
# cvt_xrandr 5120 1440 60
# cvt_xrandr 5120 2160 60
# cvt_xrandr 5120 2700 60
# cvt_xrandr 5120 2880 60
# cvt_xrandr 5120 3840 60
# cvt_xrandr 5120 4096 60
# cvt_xrandr 5120 1440 60
# cvt_xrandr 5120 2700 60
# cvt_xrandr 5120 4096 60
# cvt_xrandr 6144 3240 60
# cvt_xrandr 6400 4096 60
# cvt_xrandr 6400 4800 60
# cvt_xrandr 6400 4096 60
# cvt_xrandr 6400 4800 60
# cvt_xrandr 7168 3780 60
# cvt_xrandr 7680 4320 60
# cvt_xrandr 7680 4800 60
# cvt_xrandr 7680 4320 60
# cvt_xrandr 7680 4800 60
# cvt_xrandr 8192 4320 60
# cvt_xrandr 8192 4320 60
