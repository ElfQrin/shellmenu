#!/bin/bash

# SqlShAdmin
xver='r2020-11-12 fr2020-11-11';
# by Valerio Capello - http://labs.geody.com/ - License: GPL v3.0

# trap "" 1 2 3 20 # Traps Signals and Interrupts: blocks Ctrl+C , Ctrl+\ , Ctrl+Z , Ctrl+D (use only if the user must be forced to stay into the menu)


# Config

shwmenu=0; # Always show the menu after every operation (1: True, 0: False)
shwmenucls=0; # Clear screen before showing the menu. It will also request to hit a key after every operation (1: True, 0: False)
startcls=0; # Clear the screen at startup (1: True, 0: False)
onekeyc=1; # Single Keypress for menu choice, rather than having to hit Enter (1: True, 0: False)

xcmd="mysql"; # SQL shell command
xcmddump="mysqldump"; # SQL dump shell command

# dbhost='localhost'; # Database Host
dbusr=''; # Username for the Database (normally left empty for default)
dbpwd=''; # Password for the Database (normally left empty for default. It's not safe to set it as cleartext within the script. If not set in the script, nor set when executing the script, it will have to be entered by the user every time for any operation)
dbdb=''; # Database (normally left empty for default)
dbtb=''; # Table (normally left empty for default)

idfield='id';
limres=5; # Limit Results

tsproon="\e[0;32m"; # Prompt Text On
tsproof="\e[0m"; # Prompt Text Off
tshilon="\e[0;33m"; # Hilight Text On
tshilof="\e[0m"; # Hilight Text Off
tsalerton="\e[0;31m"; # Alert Text On
tsalertof="\e[0m"; # Alert Text Off


# Menu Operations

# Operation: Set User
xfx_db_enter_dbusr() {
echo -n "Enter User";
if [ -z "$dbusr" ]; then echo -n " [NOT set]"; fi
read -r -p ": " dbusr
}

# Operation: Set Password
xfx_db_enter_dbpwd() {
echo -n "Enter Password";
if [ -z "$dbpwd" ]; then echo -n " [NOT set]"; fi
read -r -p ": " dbpwd
}

# Operation: Select Database
xfx_db_enter_dbdb() {
echo -n "Enter Database";
if [ -z "$dbdb" ]; then echo -n " [NOT set]"; fi
read -r -p ": " dbdb
}

# Operation: Select Table
xfx_db_enter_dbtb() {
echo -n "Enter Table";
if [ -z "$dbtb" ]; then echo -n " [NOT set]"; fi
read -r -p ": " dbtb
}

# Operation: List Databases
xfx_db_list_db() {
dbusrloc='';
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
echo
$xcmd -u $dbusrloc -p${dbpwd} <<< 'show databases;'
}

# Operation: List Tables
xfx_db_list_tables() {
dbusrloc=''; dbdbloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
echo
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< 'show tables;'
}

# Operation: Show Table Structure
xfx_db_show_table_struct() {
dbusrloc=''; dbdbloc=''; dbtbloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbtb" ]; then read -r -p "Specify Table: " dbtbloc ; fi
if [ -z "$dbtb" ] && [ -z "$dbtbloc" ]; then echo "Table NOT set."; return 0; fi
if [ -z "$dbtbloc" ]; then $dbtbloc=$dbtb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
echo
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "show fields from ${dbtbloc};"
echo
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "show index from ${dbtbloc};"
echo
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "select count(*) from ${dbtbloc};"
}

# Operation: Show Table Content
xfx_db_show_table_cont() {
dbusrloc=''; dbdbloc=''; dbtbloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbtb" ]; then read -r -p "Specify Table: " dbtbloc ; fi
if [ -z "$dbtb "] && [ -z "$dbtbloc" ]; then echo "Table NOT set."; return 0; fi
if [ -z "$dbtbloc" ]; then $dbtbloc=$dbtb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
echo
echo "First ${limres} Rows:";
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "SELECT * FROM ${dbtbloc} ORDER BY ${idfield} LIMIT ${limres};"
echo
echo "Last ${limres} Rows:";
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "SELECT * FROM ${dbtbloc} ORDER BY ${idfield} DESC LIMIT ${limres};"
}

# Operation: Check Table
xfx_db_check_table() {
dbusrloc=''; dbdbloc=''; dbtbloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbtb" ]; then read -r -p "Specify Table: " dbtbloc ; fi
if [ -z "$dbtb" ] && [ -z "$dbtbloc" ]; then echo "Table NOT set."; return 0; fi
if [ -z "$dbtbloc" ]; then $dbtbloc=$dbtb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
echo
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "check table ${dbtbloc};"
}

# Operation: Repair Table
xfx_db_repair_table() {
dbusrloc=''; dbdbloc=''; dbtbloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbtb" ]; then read -r -p "Specify Table: " dbtbloc ; fi
if [ -z "$dbtb" ] && [ -z "$dbtbloc" ]; then echo "Table NOT set."; return 0; fi
if [ -z "$dbtbloc" ]; then $dbtbloc=$dbtb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
echo
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "repair table ${dbtbloc};"
}

# Operation: DB Query
xfx_db_query() {
dbusrloc=''; dbdbloc=''; dbtbloc=''; dbqloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
read -r -p "Enter Query (BE CAREFUL): " dbqloc ;
if [[ "$dbqloc" == "" ]]; then echo "Query is empty. Nothing to do."; return 0; fi
echo
$xcmd -u $dbusrloc -p${dbpwd} $dbdbloc <<< "${dbqloc}"
}


# Operation: DB Dump (Structure only)
xfx_db_dump_struct() {
dbusrloc=''; dbdbloc=''; dbtbloc=''; fnamloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
read -r -p "Enter Output Path/File Name: " fnamloc ;
if [ -z "$fnamloc" ]; then echo "File Name is empty. Nothing to do."; return 0; fi
echo
$xcmddump -v --no-data -u $dbusrloc -pPASSWORD -p${dbpwd} $dbdbloc > $fnamloc
}

# Operation: DB Dump (Data only)
xfx_db_dump_data() {
dbusrloc=''; dbdbloc=''; dbtbloc=''; fnamloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
read -r -p "Enter Output Path/File Name: " fnamloc ;
if [ -z "$fnamloc" ]; then echo "File Name is empty. Nothing to do."; return 0; fi
echo
$xcmddump -v -c --no-create-db --no-create-info -u $dbusrloc -pPASSWORD -p${dbpwd} $dbdbloc > $fnamloc
}

# Operation: DB Dump (Structure and Data)
xfx_db_dump_struct_data() {
dbusrloc=''; dbdbloc=''; dbtbloc=''; fnamloc='';
if [ -z "$dbdb" ]; then read -r -p "Specify Database: " dbdbloc ; fi
if [ -z "$dbdb" ] && [ -z "$dbdbloc" ]; then echo "Database NOT set."; return 0; fi
if [ -z "$dbdbloc" ]; then dbdbloc=$dbdb ; fi
if [ -z "$dbusr" ]; then read -r -p "Specify User: " dbusrloc ; fi
if [ -z "$dbusr" ] && [ -z "$dbusrloc" ]; then echo "User NOT set."; return 0; fi
if [ -z "$dbusrloc" ]; then dbusrloc=$dbusr ; fi
read -r -p "Enter Output Path/File Name: " fnamloc ;
if [ -z "$fnamloc" ]; then echo "File Name is empty. Nothing to do."; return 0; fi
echo
$xcmddump -v -c --add-drop-database --add-drop-table --add-locks -u $dbusrloc -pPASSWORD -p${dbpwd} $dbdbloc > $fnamloc
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
echo "SqlShAdmin $xver"
echo
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
$xcmd -V

# echo ;
# echo "MENU"
echo ;
# echo "C. Clear Screen"
echo "1. List Databases"
echo "2. List Tables in Database"
echo "3. Show Table Structure"
echo "4. Show Table Content (first/last ${limres} rows)"
echo "5. Check Table"
echo "6. Repair a corrupted Table"
echo "7. Enter a Query (potentially dangerous)"
echo "8. Dump Database (Structure only)"
echo "9. Dump Database (Data only)"
echo "0. Dump Database (Structure and Data)"
echo -n "D. Select Database: "
if [ -z "$dbdb" ]; then echo "[NOT set]"; else echo "$dbdb"; fi
echo -n "T. Select Table: "
if [ -z "$dbtb" ]; then echo "[NOT set]"; else echo "$dbtb"; fi
echo -n "U. Set User: "
if [ -z "$dbusr" ]; then echo "[NOT set]"; else echo "$dbusr"; fi
echo -n "P. Set Password: "
# if [ -z "$dbpwd" ]; then echo "[NOT set]"; else echo "$dbpwd"; fi
if [ -z "$dbpwd" ]; then echo "[NOT set]"; else echo "[SET]"; fi
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
"1") xfx_db_list_db ;;
"2") xfx_db_list_tables ;;
"3") xfx_db_show_table_struct ;;
"4") xfx_db_show_table_cont ;;
"5") xfx_db_check_table ;;
"6") xfx_db_repair_table ;;
"7") xfx_db_query ;;
"8") xfx_db_dump_struct ;;
"9") xfx_db_dump_data ;;
"0") xfx_db_dump_struct_data ;;
"d"|"D") xfx_db_enter_dbdb ;;
"t"|"T") xfx_db_enter_dbtb ;;
"u"|"U") xfx_db_enter_dbusr ;;
"p"|"P") xfx_db_enter_dbpwd ;;
"c"|"C") clear ;;
"g"|"G") xfx_ring_bell "1" ;;
"m"|"M"|"h"|"H") show_menu; wkeyi=0 ;;
"q"|"Q"|"x"|"X") exit 0 ;;
*) echo -e "${tsalerton}Invalid option.${tsalertof}" ;;
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
