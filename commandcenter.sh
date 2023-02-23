#!/bin/bash
title="Command Center online."
prompt="Pick an option: "
options=("Pihole Status" "Pihole Restart DNS" "Pihole Update Adlists" "Pihole Update Gravity" "Pihole Update" "Pihole Pause" "Pihole Resume" "Mullvad Status" "Mullvad Toggle [all]" "Mullvad Pause [all]" "Mullvad Resume [all]" "Mullvad Toggle [Router]" "Mullvad Pause [Router]" "Mullvad Resume [Router]" "Mullvad Toggle [Pi]" "Mullvad Pause [Pi]" "Mullvad Resume [Pi]" "Skynet Pause " "Skynet Resume" "Status Everything" "Pause Everything" "Resume Everything" "Siren Start" "Siren Stop" "Gaming Process Kill" "EmulationStation Start" "ScummVM Start" "Saved Games Backup" "Saved Games Restore" "RAM Usage" "CPU Usage" "Temperatures" "CPU Clock" "CPU Throttle" "GPU Clock" "Hardware" "Toggle Backlight" "Restart" "Restart Everything" "Shutdown" "Shutdown Everything" "Lock Everything")
myHostname=
otherHostname=
if [[ $HOSTNAME == "Monkeebutt" ]]
then
  myHostname="Monkeebutt"
  otherHostname="Harbormaster"
elif [[ $HOSTNAME == "Harbormaster" ]]
then
  myHostname="Harbormaster"
  otherHostname="Monkeebutt"
fi

selector=$1;

if [ ! -z "$selector" ]
then 
    case "$selector" in
    1 | status_Pihole) echo "Pihole Status";  echo $myHostname; pihole status; echo $otherHostname; ssh $otherHostname "pihole status";;
    2 | restart_Pihole) echo "Restarting Pihole"; echo $myHostname; pihole restartdns; echo $otherHostname; ssh $otherHostname "pihole restartdns";;
    3) echo "Updating Pihole Adlists"; echo $myHostname; /home/pi/adlist-sequence.sh; echo $otherHostname; ssh $otherHostname "/home/pi/adlist-sequence.sh";;
    4) echo "Updating Pihole Gravity"; echo $myHostname; pihole -g;  echo $otherHostname; ssh $otherHostname "pihole -g"; ssh $otherHostname "pihole -g";;
    5) echo "Updating Pihole"; echo $myHostname; pihole -up; echo $otherHostname; ssh $otherHostname "pihole -up";;
    6 | pause_Pihole) echo "Pausing Pihole"; echo $myHostname; pihole disable 30m; echo $otherHostname; ssh $otherHostname "pihole disable 30m";;
    7 | resume_Pihole) echo "Resuming Pihole"; echo $myHostname; pihole enable; echo $otherHostname; ssh $otherHostname "pihole enable";;
    8 | status_Mullvad) echo "Mullvad Status"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh status"; echo $myHostname; /home/pi/mullvad.sh status; echo $otherHostname; ssh $otherHostname "/home/pi/mullvad.sh status";;
    9 | toggle_Mullvad) echo "Toggling Mullvad [all]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh toggle policy"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh toggle";;
    10 | pause_Mullvad) echo "Pausing Mullvad [all]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh stop"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh stop";;
    11 | resume_Mullvad) echo "Resuming Mullvad [all]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh start policy"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh start";;
    12) echo "Toggling Mullvad [Router]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh toggle policy";;
    13) echo "Pausing Mullvad [Router]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh stop";;
    14) echo "Resuming Mullvad [Router]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh start policy";;
    15) echo "Toggling Mullvad [Pi]"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh toggle";;
    16) echo "Pausing Mullvad [Pi]"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh stop";;
    17) echo "Resuming Mullvad [Pi]"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh start";;
    18 | pause_Skynet) echo "Pausing Skynet"; ssh PortRoyal "/jffs/scripts/firewall disable";;
    19 | resume_Skynet) echo "Resuming Skynet"; ssh PortRoyal "/jffs/scripts/firewall restart";;
    20 | status) echo "Status Everything"; echo $myHostname; pihole status; /home/pi/mullvad.sh status; echo "PortRoyal"; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh status"; echo $otherHostname; ssh $otherHostname "pihole status";  ssh otherHostname "/home/pi/mullvad.sh status";;
    21 | pause) echo "Pausing Everything"; echo $myHostname; pihole disable 30m; echo "PortRoyal"; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh stop"; ssh PortRoyal "/jffs/scripts/firewall disable"; echo $otherHostname; ssh $otherHostname "pihole disable 30m"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh disable";;
    22 | resume) echo "Resuming Everything"; echo $myHostname; pihole enable; echo "PortRoyal"; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh start"; ssh PortRoyal "/jffs/scripts/firewall restart"; echo $otherHostname; ssh $otherHostname "pihole enable"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh start";;
    23 | start_siren) echo "Starting Siren"; /home/pi/Siren/SirenStart.sh;;
    24 | stop_siren) echo "Stopping Siren"; /home/pi/Siren/SirenStop.sh;;
    #for i in `cat hostlist`;do ssh -q $i kill `ssh -q $i ps -ef | grep <process name>|awk '{print $2}'`;done
    #ssh remotehost "kill -9 \$(ps -aux | grep foo | grep bar | awk '{print \$2}')"
    #25) echo "Killing Gaming Process"; ssh Tron -p 222 kill -9 ` ssh Tron -p 222 ps -ef | grep 'scummvm\|retroarch\|emulationstation'|awk '{print $2}'`;;
    25) echo "Killing Gaming Process"; ssh Tron -p 222 "kill -9 \$(ps -aux | grep 'scummvm\|retroarch\|emulationstation' | awk '{print \$2}')";;
    26 | emulationstation) echo "Starting EmulationStation and RetroArch"; ssh Tron -p 222 "su pi /usr/bin/emulationstation" &;;
    27 | ScummVM) echo "Starting ScummVM"; ssh Tron -p 222 "/usr/games/scummvm" &;;
    28 | backup_saves) echo "Backing up saved games"; ssh Tron -p 222 "find /home/pi/RetroPie/roms/ -name "*.srm" -o -name "*.state*" | tar --transform 's|/home/pi/||g' -PcJf /home/pi/savegamebackup/savegames.$(date +%Y-%m-%d).tar.xz -T -";;
    #29) echo "Restored Saved Games"; ssh Tron -p 222 "tar -C /home/pi/ -xJf /home/pi/savegamebackup/current/retropie_saves.tar.xz";;
    29) echo "Restored Saved Games"; ssh Tron -p 222 "ls -t -d -1 "/home/pi/savegamebackup/"* | head -n1 | xargs tar -C /home/pi/ -xJf";;
    30 | RAM) echo "Checking RAM Usage"; free;;
    31 | CPU) echo "Checking CPU Usage"; top;;
    32 | temp) echo "Checking Temperatures"; /home/pi/temperature.sh;;
    33 | clock) echo "Checking CPU Clock"; watch -n 1 vcgencmd measure_clock arm;;
    34 | throttle) echo "Checking CPU Throttle"; watch -n 1 vcgencmd get_throttled show;;
    35 | GPU) echo "Checking GPU Clock"; watch -n 1 vcgencmd measure_clock v3d;;
    36 | hardware) echo "Showing hardware"; /home/pi/monitor.sh;;
    37 | toggle_backlight) echo "Toggling backlight"; rpi-backlight -p toggle; sudo /home/pi/rpi-hdmi.sh toggle; ssh $otherHostname "rpi-backlight -p toggle; sudo /home/pi/rpi-hdmi.sh toggle";;
    38) echo "Restarting"; reboot;;
    39 | restart) echo "Restarting Everything"; echo "Tron"; ssh Tron -p 222 "sudo reboot"; echo $otherHostname; ssh $otherHostname "sudo reboot"; echo "Steamdeck"; ssh Steamdeck "sudo reboot"; echo "Firewalla"; ssh Firewalla "sudo reboot"; echo "PortRoyal"; ssh PortRoyal "reboot"; echo $myHostname; sudo reboot;;
    40) echo "Shutting down"; shutdown now;;
    41 | shutdown) echo "Shutting down everything"; echo "Tron"; ssh Tron -p 222 "sudo shutdown now"; echo $otherHostname; ssh $otherHostname "sudo shutdown now"; echo "Steamdeck"; ssh Steamdeck "sudo shutdown now"; echo "Firewalla"; ssh Firewalla "sudo shutdown now"; echo "PortRoyal"; ssh PortRoyal "shutdown now"; echo $myHostname; sudo shutdown now;;
    # Locking PC: psexec -s -i 1 \\HOSTNAME "C:\Windows\System32\psshutdown.exe" -l -t 0. Change DESKTOP-TRISK to your desktop name -> open cmd and type in "hostname", should display your current desktop name.
    # Sleeping PC: psshutdown -d -t 0
    # Shutdown PC: psshutdown -f -t 0
    42 | lock) echo "Locking everything"; rpi-backlight -p off; sudo /home/pi/rpi-hdmi.sh toggle; ssh $otherHostname "rpi-backlight -p off; sudo /home/pi/rpi-hdmi.sh toggle"; ssh BlackPearl "psexec -s -i 1 "psshutdown.exe" -l -t 0";;
    $((${#options[@]}+1))) exit;;
    *) echo "Invalid option.";;
    esac
fi

echo "$title"
PS3="$prompt"
select opt in "${options[@]}" "Quit";do
    case "$REPLY" in
    1 | status_Pihole) echo "Pihole Status";  echo $myHostname; pihole status; echo $otherHostname; ssh $otherHostname "pihole status";;
    2 | restart_Pihole) echo "Restarting Pihole"; echo $myHostname; pihole restartdns; echo $otherHostname; ssh $otherHostname "pihole restartdns";;
    3) echo "Updating Pihole Adlists"; echo $myHostname; /home/pi/adlist-sequence.sh; echo $otherHostname; ssh $otherHostname "/home/pi/adlist-sequence.sh";;
    4) echo "Updating Pihole Gravity"; echo $myHostname; pihole -g;  echo $otherHostname; ssh $otherHostname "pihole -g"; ssh $otherHostname "pihole -g";;
    5) echo "Updating Pihole"; echo $myHostname; pihole -up; echo $otherHostname; ssh $otherHostname "pihole -up";;
    6 | pause_Pihole) echo "Pausing Pihole"; echo $myHostname; pihole disable 30m; echo $otherHostname; ssh $otherHostname "pihole disable 30m";;
    7 | resume_Pihole) echo "Resuming Pihole"; echo $myHostname; pihole enable; echo $otherHostname; ssh $otherHostname "pihole enable";;
    8 | status_Mullvad) echo "Mullvad Status"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh status"; echo $myHostname; /home/pi/mullvad.sh status; echo $otherHostname; ssh $otherHostname "/home/pi/mullvad.sh status";;
    9 | toggle_Mullvad) echo "Toggling Mullvad [all]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh toggle policy"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh toggle";;
    10 | pause_Mullvad) echo "Pausing Mullvad [all]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh stop"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh stop";;
    11 | resume_Mullvad) echo "Resuming Mullvad [all]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh start policy"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh start";;
    12) echo "Toggling Mullvad [Router]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh toggle policy";;
    13) echo "Pausing Mullvad [Router]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh stop";;
    14) echo "Resuming Mullvad [Router]"; echo "PortRoyal "; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh start policy";;
    15) echo "Toggling Mullvad [Pi]"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh toggle";;
    16) echo "Pausing Mullvad [Pi]"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh stop";;
    17) echo "Resuming Mullvad [Pi]"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh start";;
    18 | pause_Skynet) echo "Pausing Skynet"; ssh PortRoyal "/jffs/scripts/firewall disable";;
    19 | resume_Skynet) echo "Resuming Skynet"; ssh PortRoyal "/jffs/scripts/firewall restart";;
    20 | status) echo "Status Everything"; echo $myHostname; pihole status; /home/pi/mullvad.sh status; echo "PortRoyal"; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh status"; echo $otherHostname; ssh $otherHostname "pihole status";  ssh otherHostname "/home/pi/mullvad.sh status";;
    21 | pause) echo "Pausing Everything"; echo $myHostname; pihole disable 30m; echo "PortRoyal"; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh stop"; ssh PortRoyal "/jffs/scripts/firewall disable"; echo $otherHostname; ssh $otherHostname "pihole disable 30m"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh disable";;
    22 | resume) echo "Resuming Everything"; echo $myHostname; pihole enable; echo "PortRoyal"; ssh PortRoyal "/opt/etc/wireguard.d/mullvad.sh start"; ssh PortRoyal "/jffs/scripts/firewall restart"; echo $otherHostname; ssh $otherHostname "pihole enable"; echo "Harbormaster"; ssh Harbormaster "/home/pi/mullvad.sh start";;
    23 | start_siren) echo "Starting Siren"; /home/pi/Siren/SirenStart.sh;;
    24 | stop_siren) echo "Stopping Siren"; /home/pi/Siren/SirenStop.sh;;
    #for i in `cat hostlist`;do ssh -q $i kill `ssh -q $i ps -ef | grep <process name>|awk '{print $2}'`;done
    #ssh remotehost "kill -9 \$(ps -aux | grep foo | grep bar | awk '{print \$2}')"
    #25) echo "Killing Gaming Process"; ssh Tron -p 222 kill -9 ` ssh Tron -p 222 ps -ef | grep 'scummvm\|retroarch\|emulationstation'|awk '{print $2}'`;;
    25) echo "Killing Gaming Process"; ssh Tron -p 222 "kill -9 \$(ps -aux | grep 'scummvm\|retroarch\|emulationstation' | awk '{print \$2}')";;
    26 | emulationstation) echo "Starting EmulationStation and RetroArch"; ssh Tron -p 222 "su pi /usr/bin/emulationstation" &;;
    27 | ScummVM) echo "Starting ScummVM"; ssh Tron -p 222 "/usr/games/scummvm" &;;
    28 | backup_saves) echo "Backing up saved games"; ssh Tron -p 222 "find /home/pi/RetroPie/roms/ -name "*.srm" -o -name "*.state*" | tar --transform 's|/home/pi/||g' -PcJf /home/pi/savegamebackup/savegames.$(date +%Y-%m-%d).tar.xz -T -";;
    #29) echo "Restored Saved Games"; ssh Tron -p 222 "tar -C /home/pi/ -xJf /home/pi/savegamebackup/current/retropie_saves.tar.xz";;
    29) echo "Restored Saved Games"; ssh Tron -p 222 "ls -t -d -1 "/home/pi/savegamebackup/"* | head -n1 | xargs tar -C /home/pi/ -xJf";;
    30 | RAM) echo "Checking RAM Usage"; free;;
    31 | CPU) echo "Checking CPU Usage"; top;;
    32 | temp) echo "Checking Temperatures"; /home/pi/temperature.sh;;
    33 | clock) echo "Checking CPU Clock"; watch -n 1 vcgencmd measure_clock arm;;
    34 | throttle) echo "Checking CPU Throttle"; watch -n 1 vcgencmd get_throttled show;;
    35 | GPU) echo "Checking GPU Clock"; watch -n 1 vcgencmd measure_clock v3d;;
    36 | hardware) echo "Showing hardware"; /home/pi/monitor.sh;;
    37 | toggle_backlight) echo "Toggling backlight"; rpi-backlight -p toggle; sudo /home/pi/rpi-hdmi.sh toggle; ssh $otherHostname "rpi-backlight -p toggle; sudo /home/pi/rpi-hdmi.sh toggle";;
    38) echo "Restarting"; reboot;;
    39 | restart) echo "Restarting Everything"; echo "Tron"; ssh Tron -p 222 "sudo reboot"; echo $otherHostname; ssh $otherHostname "sudo reboot"; echo "Steamdeck"; ssh Steamdeck "sudo reboot"; echo "Firewalla"; ssh Firewalla "sudo reboot"; echo "PortRoyal"; ssh PortRoyal "reboot"; echo $myHostname; sudo reboot;;
    40) echo "Shutting down"; shutdown now;;
    41 | shutdown) echo "Shutting down everything"; echo "Tron"; ssh Tron -p 222 "sudo shutdown now"; echo $otherHostname; ssh $otherHostname "sudo shutdown now"; echo "Steamdeck"; ssh Steamdeck "sudo shutdown now"; echo "Firewalla"; ssh Firewalla "sudo shutdown now"; echo "PortRoyal"; ssh PortRoyal "shutdown now"; echo $myHostname; sudo shutdown now;;
    # Locking PC: psexec -s -i 1 \\HOSTNAME "C:\Windows\System32\psshutdown.exe" -l -t 0. Change DESKTOP-TRISK to your desktop name -> open cmd and type in "hostname", should display your current desktop name.
    # Sleeping PC: psshutdown -d -t 0
    # Shutdown PC: psshutdown -f -t 0
    42 | lock) echo "Locking everything"; rpi-backlight -p off; sudo /home/pi/rpi-hdmi.sh toggle; ssh $otherHostname "rpi-backlight -p off; sudo /home/pi/rpi-hdmi.sh toggle"; ssh BlackPearl "psexec -s -i 1 "psshutdown.exe" -l -t 0";;
    $((${#options[@]}+1))) exit;;
    *) echo "Invalid option.";;
    esac
done


