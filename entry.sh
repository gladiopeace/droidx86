service ssh start
/root/noVNC/utils/launch.sh &>/dev/null &
#emulator -avd avd1 -no-window -force-32bit -qemu -vnc :0  &>/dev/null &
emulator -avd avd1 -verbose -no-window -force-32bit -qemu -vnc :0  
