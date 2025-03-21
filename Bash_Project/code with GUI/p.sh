#!/bin/bash

DB_DIR="./databases"
mkdir -p $DB_DIR

main_menu() {
    while true; do
        choice=$(dialog --title "Main Menu" --menu "Choose an option" 15 50 5 \
            1 "Create Database" \
            2 "List Databases" \
            3 "Connect To Database" \
            4 "Drop Database" \
            5 "Exit" \
            3>&1 1>&2 2>&3)

        # Check if the user pressed Cancel or Escape
        if [ $? -ne 0 ]; then
            clear
            exit 0
        fi

        case $choice in
            1) create_database ;;
            2) list_databases ;;
            3) connect_to_database ;;
            4) drop_database ;;
            5) clear; exit 0 ;;
            *) dialog --msgbox "Invalid choice" 6 20 ;;
        esac
    done
}

create_database() {
    db_name=$(dialog --inputbox "Enter the name of the new database:" 8 40 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ]; then
        mkdir -p "$DB_DIR/$db_name"
        dialog --msgbox "Database '$db_name' created successfully!" 6 40
    fi
}

list_databases() {
    db_list=$(ls $DB_DIR)
    if [ -z "$db_list" ]; then
        dialog --msgbox "No databases found!" 6 30
    else
        dialog --msgbox "Databases:\n$db_list" 15 50
    fi
}

connect_to_database() {
    db_name=$(dialog --inputbox "Enter the name of the database to connect to:" 8 40 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ]; then
        if [ -d "$DB_DIR/$db_name" ]; then
            dialog --msgbox "Connected to database '$db_name'." 6 40
        else
            dialog --msgbox "Database '$db_name' does not exist!" 6 40
        fi
    fi
}

drop_database() {
    db_name=$(dialog --inputbox "Enter the name of the database to drop:" 8 40 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ]; then
        if [ -d "$DB_DIR/$db_name" ]; then
            rm -r "$DB_DIR/$db_name"
            dialog --msgbox "Database '$db_name' dropped successfully!" 6 40
        else
            dialog --msgbox "Database '$db_name' does not exist!" 6 40
        fi
    fi
}

# Run the main menu
main_menu
