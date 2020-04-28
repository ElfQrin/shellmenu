#!/bin/bash

# Menu
# r2020-04-28 fr2020-04-28
# by Valerio Capello - http://labs.geody.com/ - License: GPL v3.0

# trap "" 1 2 3 20 # Traps Signals and Interrupts: blocks Ctrl+C , Ctrl+\ , Ctrl+Z , Ctrl+D (use only if the user must be forced to stay into the menu)


# Config

shwmenu=0; # Always show the menu after every operation (1: True, 0: False)
shwmenucls=1; # Clear screen before showing the menu. It will also request to hit a key after every operation (1: True, 0: False)
startcls=1; # Clear the screen at startup (1: True, 0: False)
onekeyc=1; # Single Keypress for menu choice, rather than having to hit Enter (1: True, 0: False)

# xedit=jed ; # Editor of choice

tsproon="\e[0;32m"; # Prompt Text On
tsproof="\e[0m"; # Prompt Text Off
tshilon="\e[0;33m"; # Hilight Text On
tshilof="\e[0m"; # Hilight Text Off
tsalerton="\e[0;31m"; # Alert Text On
tsalertof="\e[0m"; # Alert Text Off


# Menu Operations

# Operation: Hello World
xfx_hello_world() {
echo "Hello World!";
# waitkey ; # echo ;
}

# Operation: Show Date and Time
xfx_show_time() {
date "+%a %d %b %Y %H:%M:%S %Z (UTC%:z)"
}

# Operation: Ring the Bell
xfx_ring_bell() {
# echo "*Bell*";
local TIMES="$1"
if [ "$TIMES" == "" ]; then TIMES=1; fi
if [ "$TIMES" -le 0 ]; then TIMES=0;
else
for ((i=1; i <= $TIMES; i++)); do
# echo -n "$i ";
printf '\7'; sleep 0.2;
done
# echo
fi
}


# App Functions

greetings() {
echo -n "Hello "; echo -ne "$tshilon"; echo -n "$(whoami)"; echo -ne "$tshilof";
if [ "$SSH_CONNECTION" ]; then
echo -n " ("; echo -ne "$tshilon"; echo -n "`echo $SSH_CLIENT | awk '{print $1}'`"; echo -ne "$tshilof)";
fi
echo -n ", ";

echo -n "this is "; echo -ne "$tshilon"; echo -n "$(hostname)"; echo -ne "$tshilof";
# echo -n " ("; echo -ne "$tshilon"; echo -n "$(hostname -i)"; echo -ne "$tshilof)";
echo ".";
}

waitkey() {
read -rs -n 1 -p "Press any key to continue..." wkey
}

# Display Menu (Function)

show_menu() {
if [ $shwmenucls -eq 1 ]; then clear ; fi
greetings
xfx_show_time
echo ;
echo "MENU"
echo ;
echo "1. Hello World!"
echo "2. Show Date and Time"
# echo "C. Clear Screen"
echo "G. Ring the Bell"
echo "M. Show This Menu"
echo "Q. Quit"
}


# Call requested operation

choose_option() {
local choice
echo -ne "$tsproon";
echo -n "Enter choice ";
if [ $shwmenu -eq 0 ]; then echo -n "[M for Menu] "; fi
echo -n ": ";
echo -ne "$tsproof";
if [ $onekeyc -eq 1 ]; then
read -r -n 1 -p "" choice # Key press
echo ;
else
read -r -p "" choice # Type choice and hit Enter
fi
local wkeyi=1;
case $choice in
"1") xfx_hello_world ;;
"2") xfx_show_time ;;
"c"|"C") clear ;;
"g"|"G") xfx_ring_bell "1" ;;
"m"|"M"|"h"|"H") show_menu; wkeyi=0 ;;
"q"|"Q"|"x"|"X") exit 0 ;;
*) echo -e "${tsalerton}Invalid option.${tsalertof}"
esac
if [ $shwmenu -eq 1 ] && [ $shwmenucls -eq 1 ] && [ $wkeyi -eq 1 ]; then
waitkey ; # echo ; # sleep 2 ;
fi
}


# Main

if [ $startcls -eq 1 ]; then clear ; fi
if [ $shwmenu -eq 0 ]; then show_menu ; fi
while true
do
echo ;
if [ $shwmenu -eq 1 ]; then show_menu ; fi
choose_option
done
