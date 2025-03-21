#!/bin/bash

DB_DIR="./databases"
mkdir -p $DB_DIR

main_menu() {
    while true; do
        choice=$(zenity --list --title="Main Menu" --column="Choice" --column="Action" \
            1 "Create Database" \
            2 "List Databases" \
            3 "Connect To Database" \
            4 "Drop Database" \
            5 "Exit" --width=600 --height=400)
           if [ $? -ne 0 ]; then
                exit 0
            fi

        case $choice in
            1) create_database ;;
            2) list_databases ;;
            3) connect_to_database ;;
            4) drop_database ;;
            5) exit 0 ;;
            *) zenity --error --text="Invalid choice" ;;
        esac
    done
}
create_database() {
    db_Name=$(zenity --entry --title="Create Database" --text="Enter your Database Name:" --width=400 --height=200)
    if [ -z "$db_Name" ]; then
        zenity --error --text="You must input a database name."
        main_menu
    fi

    if [ -d "$DB_DIR/$db_Name" ]; then
        zenity --error --text="Database already exists"
    else
        mkdir "$DB_DIR/$db_Name"
        zenity --info --text="Database '$db_Name' created successfully"
    fi
    exit_status=$?
        if [ $exit_status -eq 1 ]; then
            main_menu
        elif [ $exit_status -ne 0 ]; then
            exit 0
        fi
}

list_databases() {
    databases=$(ls $DB_DIR | grep -v '\.data$')
    zenity --info --title="List Databases" --text="Databases:\n$databases" --width=800 --height=600
    exit_status=$?
        if [ $exit_status -eq 1 ]; then
            main_menu
        elif [ $exit_status -ne 0 ]; then
            exit 0
        fi
}

connect_to_database() {
    db_Name=$(zenity --entry --title="Connect To Database" --text="Enter your Database Name:" --width=400 --height=200)
    if [ -z "$db_Name" ]; then
        zenity --error --text="You must input a database name."
        main_menu
    fi
    if [ -d "$DB_DIR/$db_Name" ]; then
        db_menu "$db_Name"
    else
        zenity --error --text="Database '$db_Name' not found"
    fi
    exit_status=$?
        if [ $exit_status -eq 1 ]; then
            main_menu
        elif [ $exit_status -ne 0 ]; then
            exit 0
        fi
}

drop_database() {
    db_Name=$(zenity --entry --title="Drop Database" --text="Enter your Database Name:" --width=400 --height=200)
    if [ -z "$db_Name" ]; then
        zenity --error --text="You must input a database name."
        main_menu
    fi

    if [ -d "$DB_DIR/$db_Name" ]; then
        zenity --question --text="Are you sure you want to drop the database '$db_Name'?"
        exit_status=$?
        if [ $exit_status -eq 1 ]; then
            main_menu
        elif [ $exit_status -ne 0 ]; then
            exit 0
        fi
        if [ $? -eq 0 ]; then
            rm -r "$DB_DIR/$db_Name"
            zenity --info --text="Database '$db_Name' dropped successfully"
        fi
    else
        zenity --error --text="Database '$db_Name' not found"
    fi
    
    
}
db_menu() {
    local db_name=$1
    while true; do
        choice=$(zenity --list --title="Database: $db_name" --column="Choice" --column="Action" \
            1 "Create Table" \
            2 "List Tables" \
            3 "Drop Table" \
            4 "Insert into Table" \
            5 "Select From Table" \
            6 "Delete From Table" \
            7 "Update Table" \
            8 "Back to Main Menu" --width=600 --height=400)
            if [ $? -ne 0 ]; then
                exit 0
            fi

        case $choice in
            1) create_table "$db_name" ;;
            2) list_tables "$db_name" ;;
            3) drop_table "$db_name" ;;
            4) insert_into_table "$db_name" ;;
            5) select_from_table "$db_name" ;;
            6) delete_from_table "$db_name" ;;
            7) update_table "$db_name" ;;
            8) break ;;
            *) zenity --error --text="Invalid choice" ;;
        esac
    done
}

create_table() {
    local db_name=$1
    table_name=$(zenity --entry --title="Create Table" --text="Enter table name:" --width=400 --height=200)
    if [ -z "$table_name" ]; then
        zenity --error --text="You must input a table name."
        db_menu "$db_name"
    fi
    if [[ ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        zenity --error --text="Invalid table name. Table names must start with a letter or underscore and contain only alphanumeric characters and underscores."
        db_menu "$db_name"
    fi
    if [ -f "$DB_DIR/$db_name/$table_name" ]; then
        zenity --error --text="Table '$table_name' already exists!"
        db_menu "$db_name"
    fi
    mkdir -p "$DB_DIR/$db_name" 
    local valid_input=false
    while [ "$valid_input" = false ]; do
        columns=$(zenity --entry --title="Create Table" --text="Enter columns (name type, e.g., id int name string):")
        local column_array=()
        local type_array=()
        local invalid=false
        local col_counter=0
        for word in $columns; do
            if (( col_counter % 2 == 0 )); then
                
                if [[ ! "$word" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                    zenity --error --text="Invalid column name: '$word'. Column names must start with a letter or underscore and contain only alphanumeric characters and underscores."
                    invalid=true
                    break
                fi
                column_array+=("$word")
            else
                
                if [[ ! "$word" =~ ^(int|string|float|bool)$ ]]; then
                    zenity --error --text="Invalid column type: '$word'. Valid types are int, string, float, or bool."
                    invalid=true
                    break
                fi
                type_array+=("$word")
            fi
            ((col_counter++))
        done
        if (( col_counter % 2 != 0 )); then
            zenity --error --text="Column and type mismatch. Please enter columns in pairs (name type)."
            invalid=true
        fi
        if [ "$invalid" = false ]; then
            
            while true; do
                pk_column=$(zenity --entry --title="Create Table" --text="Enter the primary key column:")
                if [[ " ${column_array[@]} " =~ " $pk_column " ]]; then
                    
                    pk_index=$(echo "${column_array[@]}" | tr ' ' '\n' | grep -n -w "$pk_column" | cut -d: -f1)
                    pk_index=$((pk_index - 1)) 
                   
                    column_array=("${column_array[$pk_index]}" "${column_array[@]:0:$pk_index}" "${column_array[@]:$((pk_index + 1))}")
                    type_array=("${type_array[$pk_index]}" "${type_array[@]:0:$pk_index}" "${type_array[@]:$((pk_index + 1))}")
                    valid_input=true
                    break
                else
                    zenity --error --text="Primary key column '$pk_column' does not exist. Please choose a valid column."
                fi
            done
        else
            zenity --error --text="Please re-enter the columns."
        fi
    done
    
    {
        for ((i = 0; i < ${#column_array[@]}; i++)); do
            echo "${column_array[$i]}:${type_array[$i]}"
        done
        echo "PRIMARY_KEY:$pk_column"
    } > "$DB_DIR/$db_name/$table_name"
    zenity --info --text="Table '$table_name' created successfully with primary key '$pk_column'!"
}

list_tables() {
    local db_name=$1
     
    tables=$(ls "$DB_DIR/$db_name"| grep -v '\.data$' --width=400 --height=200)
    zenity --info --title="List Tables" --text="Tables:\n$tables"
}

drop_table() {
    local db_name=$1
    table_name=$(zenity --entry --title="Drop Table" --text="Enter your Table Name:" --width=400 --height=200)
    if [ -f "$DB_DIR/$db_name/$table_name" ]; then
        zenity --question --text="Are you sure you want to drop the table '$table_name'?"
        if [ $? -eq 0 ]; then
            rm "$DB_DIR/$db_name/$table_name"
            rm "$DB_DIR/$db_name/$table_name.data"
            zenity --info --text="Table '$table_name' dropped successfully"
        fi
    else
        zenity --error --text="Table '$table_name' not found"
    fi
}
insert_into_table() {
    local db_name=$1
    table_name=$(zenity --entry --title="Insert into Table" --text="Enter table name:" --width=400 --height=200)
    if [ -z "$table_name" ]; then
        zenity --error --text="You must input a table name."
        db_menu "$db_name"
    fi

    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        zenity --error --text="Table '$table_name' does not exist!"
        db_menu "$db_name"
    fi
   
    columns=()
    types=()
    pk_column=""
    pk_index=-1
    line_counter=0
    while read -r line; do
        name=$(echo $line | cut -d: -f1)
        type=$(echo $line | cut -d: -f2)
        if [[ "$name" == "PRIMARY_KEY" ]]; then
            pk_column="$type"
            pk_index=$line_counter 
        fi
    done < "$DB_DIR/$db_name/$table_name"
    
    while read -r line; do
        name=$(echo $line | cut -d: -f1)
        type=$(echo $line | cut -d: -f2)
        if [[ ! "$name" == "PRIMARY_KEY" ]]; then
            columns+=("$name")
            types+=("$type")
            fi
        ((line_counter++))
    done < "$DB_DIR/$db_name/$table_name"


    if [ -z "$pk_column" ]; then
        zenity --error --text="Error: No primary key defined for table '$table_name'."
        db_menu "$db_name"
    fi

    
    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        touch "$DB_DIR/$db_name/$table_name.data"
    fi

    row_data=()
    for i in "${!columns[@]}"; do
        while true; do
            value=$(zenity --entry --title="Insert into Table" --text="Enter value for ${columns[$i]} (${types[$i]}):")
            case "${types[$i]}" in
                int)
                    if [[ ! "$value" =~ ^[0-9]+$ ]]; then
                        zenity --error --text="Invalid value for ${columns[$i]}. Expected an integer."
                        continue
                    fi
                    ;;
                float)
                    if [[ ! "$value" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                        zenity --error --text="Invalid value for ${columns[$i]}. Expected a float."
                        continue
                    fi
                    ;;
                bool)
                    if [[ ! "$value" =~ ^(true|false)$ ]]; then
                        zenity --error --text="Invalid value for ${columns[$i]}. Expected a boolean."
                        continue
                    fi
                    ;;
                string)
                    if [[ -z "$value" ]]; then
                        zenity --error --text="Invalid value for ${columns[$i]}. Cannot be empty."
                        continue
                    fi
                    ;;
            esac
            row_data+=("$value")
            break
        done
    done

    pk_value="${row_data[$pk_index]}"
    if grep -q "^$pk_value " "$DB_DIR/$db_name/$table_name.data"; then
        zenity --error --text="Error: Duplicate primary key value '$pk_value'."
        db_menu "$db_name"
    fi

    printf "%s\n" "${row_data[*]}" >> "$DB_DIR/$db_name/$table_name.data"
    zenity --info --text="Row inserted successfully!"
}

select_from_table() {
    local db_name=$1
    table_name=$(zenity --entry --title="Select From Table" --text="Enter table name:" --width=400 --height=200)
    if [ -z "$table_name" ]; then
        zenity --error --text="You must input a table name."
        db_menu "$db_name"
    fi

    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        zenity --error --text="Table '$table_name' does not exist!" --width=800 --height=600
        db_menu "$db_name"
    fi

    columns=()
    pk_column=""
    while read -r line; do
        name=$(echo $line | cut -d: -f1)
        if [[ "$name" == "PRIMARY_KEY" ]]; then
            pk_column=$(echo $line | cut -d: -f2)
        else
            columns+=("$name")
        fi
    done < "$DB_DIR/$db_name/$table_name"

    if [ "${#columns[@]}" -eq 0 ]; then
        zenity --error --text="Table '$table_name' has no columns defined." --width=800 --height=600
        db_menu "$db_name"
    fi

    search_value=$(zenity --entry --title="Select From Table" --text="Enter value to search (leave empty to show all rows):" --width=800 --height=600)
    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        zenity --error --text="No data found for table '$table_name'" --width=800 --height=600
        db_menu "$db_name"
    fi

    column_list=$(printf "%-15s" "${columns[@]}")

    
    data_rows=$(awk -v search="$search_value" -v cols="${#columns[@]}" '
    BEGIN {
        FS=" "
        OFS=" "
    }
    {
        if (search == "" || $0 ~ search) {
            for (i = 1; i <= NF; i++) {
                printf "%-15s", $i
                if (i < NF) {
                    printf " "
                }
            }
            print ""
        }
    }' "$DB_DIR/$db_name/$table_name.data")

    
    zenity --text-info --title="Select From Table" --width=800 --height=600 --filename=<(echo -e "$column_list\n$(printf '%0.s-' {1..15})\n$data_rows")
}
delete_from_table() {
    local db_name=$1
    table_name=$(zenity --entry --title="Delete From Table" --text="Enter table name:" --width=400 --height=200)
    if [ -z "$table_name" ]; then
        zenity --error --text="You must input a table name."
        db_menu "$db_name"
    fi
    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        zenity --error --text="Table '$table_name' does not exist!"
        db_menu "$db_name"
    fi

    columns=()
    pk_column=""
    pk_index=-1
    while read -r line; do
        name=$(echo $line | cut -d: -f1)
        type=$(echo $line | cut -d: -f2)
        if [[ "$name" == "PRIMARY_KEY" ]]; then
            pk_column="$type"
            pk_index=${#columns[@]}
        else
            columns+=("$name")
        fi
    done < "$DB_DIR/$db_name/$table_name"

    if [ -z "$pk_column" ]; then
        zenity --error --text="Error: No primary key defined for table '$table_name'."
        db_menu "$db_name"
    fi

    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        zenity --error --text="No data found for table '$table_name'"
        db_menu "$db_name"
    fi

    pk_value=$(zenity --entry --title="Delete From Table" --text="Enter the primary key value to delete:")
    found=false
    temp_file=$(mktemp)
    while read -r line; do
        value=$(echo $line | cut -d' ' -f1)
        if [ "$value" == "$pk_value" ]; then
            found=true
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$DB_DIR/$db_name/$table_name.data"

    if [ "$found" == true ]; then
        mv "$temp_file" "$DB_DIR/$db_name/$table_name.data"
        zenity --info --text="Row with primary key '$pk_value' deleted successfully!"
    else
        zenity --error --text="No row found with primary key '$pk_value'."
    fi
}
update_table() {
    local db_name=$1
    table_name=$(zenity --entry --title="Update Table" --text="Enter table name:" --width=400 --height=200)
    if [ -z "$table_name" ]; then
        zenity --error --text="You must input a table name."
        db_menu "$db_name"
    fi
    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        zenity --error --text="Table '$table_name' does not exist!"
        db_menu "$db_name"
    fi

    columns=()
    types=()
    pk_column=""
    pk_index=-1
    while read -r line; do
        name=$(echo $line | cut -d: -f1)
        type=$(echo $line | cut -d: -f2)
        if [[ "$name" == "PRIMARY_KEY" ]]; then
            pk_column="$type"
            pk_index=${#columns[@]}
        else
            columns+=("$name")
            types+=("$type")
        fi
    done < "$DB_DIR/$db_name/$table_name"

    if [ -z "$pk_column" ]; then
        zenity --error --text="Error: No primary key defined for table '$table_name'."
        db_menu "$db_name"
    fi

    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        zenity --error --text="No data found for table '$table_name'"
        db_menu "$db_name"
    fi

    pk_value=$(zenity --entry --title="Update Table" --text="Enter the primary key value to update:")
    row_to_update=""
    while read -r line; do
        row_pk_value=$(echo $line | cut -d' ' -f1)
        if [ "$row_pk_value" == "$pk_value" ]; then
            row_to_update="$line"
            break
        fi
    done < "$DB_DIR/$db_name/$table_name.data"

    if [ -z "$row_to_update" ]; then
        zenity --error --text="Error: Row with primary key '$pk_value' not found."
        db_menu "$db_name"
    fi

    zenity --info --title="Current Data" --text="Current data for primary key '$pk_value':\n$row_to_update"

    col_nums_input=$(zenity --entry --title="Update Table" --text="Enter column numbers to update (e.g., 1 2 3):")
    IFS=' ' read -r -a col_nums <<< "$col_nums_input"

    for col_num in "${col_nums[@]}"; do
        if [[ ! "$col_num" =~ ^[0-9]+$ ]] || [ "$col_num" -lt 1 ] || [ "$col_num" -gt "${#columns[@]}" ]; then
            zenity --error --text="Invalid column number: $col_num."
            db_menu "$db_name"
        fi
    done

    new_values=()
    for col_num in "${col_nums[@]}"; do
        column_name="${columns[$((col_num - 1))]}"
        column_type="${types[$((col_num - 1))]}"
        while true; do
            new_value=$(zenity --entry --title="Update Table" --text="Enter new value for $column_name ($column_type):")
            case "$column_type" in
                int)
                    if [[ ! "$new_value" =~ ^[0-9]+$ ]]; then
                        zenity --error --text="Invalid value for $column_name. Expected an integer."
                        continue
                    fi
                    ;;
                float)
                    if [[ ! "$new_value" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                        zenity --error --text="Invalid value for $column_name. Expected a float."
                        continue
                    fi
                    ;;
                bool)
                    if [[ ! "$new_value" =~ ^(true|false)$ ]]; then
                        zenity --error --text="Invalid value for $column_name. Expected true or false."
                        continue
                    fi
                    ;;
                string)
                    if [[ -z "$new_value" ]]; then
                        zenity --error --text="Invalid value for $column_name. Cannot be empty."
                        continue
                    fi
                    ;;
                *)
                    zenity --error --text="Invalid column type."
                    db_menu "$db_name"
                    ;;
            esac
            new_values+=("$new_value")
            break
        done
    done

    updated_row="$row_to_update"
    for i in "${!col_nums[@]}"; do
        col_num=${col_nums[$i]}
        updated_row=$(echo "$updated_row" | awk -v col="$col_num" -v new_value="${new_values[$i]}" '{ $col = new_value; print }')
    done

    temp_file=$(mktemp)
    while read -r line; do
        row_pk_value=$(echo $line | cut -d' ' -f1)
        if [ "$row_pk_value" == "$pk_value" ]; then
            echo "$updated_row" >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$DB_DIR/$db_name/$table_name.data"

    mv "$temp_file" "$DB_DIR/$db_name/$table_name.data"
    zenity --info --text="Row updated successfully!"
}

main_menu