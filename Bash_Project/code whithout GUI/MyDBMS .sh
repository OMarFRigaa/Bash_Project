#!/bin/bash
DB_DIR="./databases"

mkdir -p $DB_DIR

main_menu() {
    clear
    echo "========== Main Menu =========="
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect To Database"
    echo -e "4) Drop Database \U26A0 "
    echo -e "5) Exit \U1F44B"
    echo "================================"
    read -p "Enter your choice: " choice
    case $choice in
        1) create_database ;;
        2) list_databases ;;
        3) connect_to_database ;;
        4) drop_database ;;
        5) exit 0 ;;
        *) echo -e "Invalid choice \U1F9D0" && sleep 3 && main_menu ;;
    esac
}
create_database(){
	read -p "Enter your Database Name: " db_Name
	if [ -d "$DB_DIR/$db_Name" ]
	then
		echo -e "Database already exists \U1F615"
	else
		mkdir "$DB_DIR/$db_Name"
		echo -e "Database '$db_Name' creaded succesfully \U1F973"
	fi
	read -p "Press any key to return to the main menu "
	main_menu
}
list_databases(){
	echo "U Databases"
	ls $DB_DIR
	read -p "Press any key to return to the main menu "
	main_menu
}
connect_to_database(){
	read -p "Enter your Database Name: " db_Name
        if [ -d "$DB_DIR/$db_Name" ]
        then
                db_menu "$db_Name"
        else
                echo -e "Database '$db_Name' not found \U1F9D0"
        fi
        read -p "Press any key to return to the main menu "
        main_menu
}	
drop_database(){
	echo -e "if you are sure press 1 \U26A0 \U26A0 "
	read x
	if [ $x -eq 1 ]
	then
        	read -p "Enter your Database Name: " db_Name
        	if [ -d "$DB_DIR/$db_Name" ]
        	then
                	rm -r "$DB_DIR/$db_Name"
			echo -e "Database '$db_Name' dropped successfully \U1F622"

        	else
                	echo -e "Database '$db_Name' not found \U1F9D0"
        	fi
        	read -p "Press any key to return to the main menu "
	fi
        main_menu
}
db_menu() {
    local db_name=$1
    clear
    echo "========== Database: $db_name =========="
    echo "1) Create Table"
    echo "2) List Tables"
    echo "3) Drop Table"
    echo "4) Insert into Table"
    echo "5) Select From Table"
    echo "6) Delete From Table"
    echo "7) Update Table"
    echo "8) Back to Main Menu"
    echo "========================================"
    read -p "Enter your choice: " choice
    case $choice in
        1) create_table "$db_name" ;;
        2) list_tables "$db_name" ;;
        3) drop_table "$db_name" ;;
        4) insert_into_table "$db_name" ;;
        5) Select_From_Table "$db_name" ;;
        6) delete_from_table "$db_name" ;;
        7) update_table "$db_name" ;;
        8) main_menu ;;
        *) echo "Invalid choice!" && sleep 2 && db_menu "$db_name" ;;
    esac
}
#create_table() {
    #local db_name=$1
    #read -p "Enter table name: " table_name

   # if [ -f "$DB_DIR/$db_name/$table_name" ]
   # then
   #     echo "Table '$table_name' already exists!"
  #  else

 #       f=1
 #       while [ "$f" -eq 1 ] 
#	do
 #           read -p "Enter columns (name type,ex. id int name string): " columns
#
   #         f=0
  #          echo "$columns" | awk '{for(i=1;i<=NF;i+=2) print $i, $(i+1)}' | while read column name type;do
 #
 #               if [[ ! "$type" =~ ^(int|string|float|bool)$ && ! "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$   ]]
#	       	then
     #               echo "Invalid column type: '$type' "
    #                f=1
   #                 break
  #             fi
 #           done
#
     #       if [ ! "$f" ]; then
    #            echo "$columns" > "$DB_DIR/$db_name/$table_name"
  #              echo "Table '$table_name' created successfully!"
 #           fi
 
   #    done
   # 
  #  sleep 2
 #   db_menu "$db_name"
#}

# create_table() {
#     local db_name=$1
#     read -p "Enter table name: " table_name

#     if [[ ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
#         echo "Invalid table name. Table names must start with a letter or underscore and contain only alphanumeric characters and underscores."
#         create_table "$db_name"
        
#     fi

#     if [ -f "$DB_DIR/$db_name/$table_name" ]; then
#         echo "Table '$table_name' already exists!"
#     else
#         valid_input=false
       
#         while [ "$valid_input" = false ]; do
#             read -p "Enter columns (name type, e.g., id int name string): " columns

#             column_array=()
#             type_array=()
#             invalid=false

#             col_counter=0
#             current_column=""
#             current_type=""
            

#             for word in $columns; do
#                 if (( col_counter % 2 == 0 )); then
#                     current_column=$word
#                     if [[ ! "$current_column" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
#                         echo "Invalid column name: '$current_column'. Column names must start with a letter or underscore and contain only alphanumeric characters and underscores."
#                         invalid=true
#                         break
#                     fi
#                 else
#                     current_type=$word
#                     if [[ ! "$current_type" =~ ^(int|string|float|bool)$ ]]; then
#                         echo "Invalid column type: '$current_type'. Valid types are int, string, float, or bool."
#                         invalid=true
#                         break
#                     fi
#                     column_array+=("$current_column")
#                     type_array+=("$current_type")
#                 fi
#                 ((col_counter++))
#             done
#             if [ "$col_counter" -lt 2 ]; then
#                 echo "where is the type"
#                 create_table "$db_name"
        
#             fi
            
#             if [ "$invalid" = false ]; then
#                 fp=1
#                 pk_in=-1
#                 cur=0
#                 while [ "$fp" -eq 1 ]; do
#                     fp=0
#                     read -p "Enter the primary key column: " pk_column

#                     pk_found=false
#                     for col in "${column_array[@]}"; do
#                         if [ "$col" == "$pk_column" ]; then
#                             pk_in=$cur
#                             pk_found=true
                            

#                             break
#                         fi
#                         ((cur++))
#                     done
#                     temp=""
#                     if [ "$pk_found" = false ]; then
#                         echo "Primary key column '$pk_column' does not exist. Please choose a valid column."
#                         fp=1
#                         temp="$column_array[$1]"
#                         $column_array[$1]="$pk_column"
#                         $column_array[$cur]="$pk_column"                        

#                     fi
#                 done

#                 valid_input=true
#                 {
#                     for ((i = 0; i < ${#column_array[@]}; i++)); do
#                         echo "${column_array[$i]}:${type_array[$i]}"
#                     done
#                     echo "PRIMARY_KEY:$pk_column"
#                 } > "$DB_DIR/$db_name/$table_name"
#                 echo "Table '$table_name' created successfully with primary key '$pk_column'!"
#             else
#                 echo "Please enter the columns again."
#             fi
#         done
#     fi
#     sleep 2
#     db_menu "$db_name"
# }     
create_table() {
    local db_name=$1
    read -p "Enter table name: " table_name

    if [[ ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid table name. Table names must start with a letter or underscore and contain only alphanumeric characters and underscores."
        return
    fi

    if [ -f "$DB_DIR/$db_name/$table_name" ]; then
        echo "Table '$table_name' already exists!"
        return
    fi

    mkdir -p "$DB_DIR/$db_name"  # Ensure the database directory exists

    local valid_input=false
    while [ "$valid_input" = false ]; do
        read -p "Enter columns (name type, e.g., id int name string): " columns
        local column_array=()
        local type_array=()
        local invalid=false
        local col_counter=0

        for word in $columns; do
            if (( col_counter % 2 == 0 )); then
                # Check column name
                if [[ ! "$word" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                    echo "Invalid column name: '$word'. Column names must start with a letter or underscore and contain only alphanumeric characters and underscores."
                    invalid=true
                    break
                fi
                column_array+=("$word")
            else
                # Check column type
                if [[ ! "$word" =~ ^(int|string|float|bool)$ ]]; then
                    echo "Invalid column type: '$word'. Valid types are int, string, float, or bool."
                    invalid=true
                    break
                fi
                type_array+=("$word")
            fi
            ((col_counter++))
        done

        if (( col_counter % 2 != 0 )); then
            echo "Column and type mismatch. Please enter columns in pairs (name type)."
            invalid=true
        fi

        if [ "$invalid" = false ]; then
            # Primary key input and place it at the start
            while true; do
                read -p "Enter the primary key column: " pk_column
                if [[ " ${column_array[@]} " =~ " $pk_column " ]]; then
                    # Move the primary key column to the front
                    pk_index=$(echo "${column_array[@]}" | tr ' ' '\n' | grep -n -w "$pk_column" | cut -d: -f1)
                    pk_index=$((pk_index - 1))  # Adjust index for 0-based array
                    # Move the primary key column to the front of the array
                    column_array=("${column_array[$pk_index]}" "${column_array[@]:0:$pk_index}" "${column_array[@]:$((pk_index + 1))}")
                    type_array=("$(echo "${type_array[$pk_index]}")" "${type_array[@]:0:$pk_index}" "${type_array[@]:$((pk_index + 1))}")
                    valid_input=true
                    break
                else
                    echo "Primary key column '$pk_column' does not exist. Please choose a valid column."
                fi
            done
        else
            echo "Please re-enter the columns."
        fi
    done

    # Save table metadata with primary key as first column
    {
        for ((i = 0; i < ${#column_array[@]}; i++)); do
            echo "${column_array[$i]}:${type_array[$i]}"
        done
        echo "PRIMARY_KEY:$pk_column"
    } > "$DB_DIR/$db_name/$table_name"

    echo "Table '$table_name' created successfully with primary key '$pk_column'!"
    sleep 2
    db_menu "$db_name"
}

list_tables(){
	local db_name=$1
	ls "$DB_DIR/$db_Name"
	read -p "Press any key to return to the main menu "
        db_menu "$db_name"
}	
drop_table(){
	local db_name=$1
        echo -e "if you are sure press 1 \U26A0 \U26A0 "
        read x
        if [ $x -eq 1 ]
        then
                read -p "Enter your Table Name: " T_name
                if [ -f "$DB_DIR/$db_Name/$T_name" ]
                then
                        rm "$DB_DIR/$db_Name/$T_name"
			rm "$DB_DIR/$db_Name/$T_name.data"

                        echo -e "Table '$T_name' dropped successfully \U1F622"

                else
                        echo -e "Table '$T_name' not found \U1F9D0"
                fi
                read -p "Press any key to return to the main menu "
        fi
        db_menu "$db_name"

}

insert_into_table() {
    local db_name=$1
    read -p "Enter table name: " table_name

    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        echo "Table '$table_name' does not exist!"
        insert_into_table "$db_name"
        return
    fi

    # Read columns and types from the table definition
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
            pk_index=$line_counter  # Set pk_index when PRIMARY_KEY is found
        fi
    done < "$DB_DIR/$db_name/$table_name"

    # Extract column names and types (excluding PRIMARY_KEY)
    while read -r line; do
        name=$(echo $line | cut -d: -f1)
        type=$(echo $line | cut -d: -f2)
        if [[ ! "$name" == "PRIMARY_KEY" ]]; then
            columns+=("$name")
            types+=("$type")
            ((line_counter++))
        fi
    done < "$DB_DIR/$db_name/$table_name"

    # Ensure a primary key is defined
    if [ -z "$pk_column" ]; then
        echo "Error: No primary key defined for table '$table_name'."
        insert_into_table "$db_name"
        return
    fi

    # Ensure the .data file exists for storing rows
    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        touch "$DB_DIR/$db_name/$table_name.data"
    fi

    echo "Enter data for table '$table_name':"
    row_data=()

    # Collect values for each column
    for i in "${!columns[@]}"; do
        while true; do
            read -p "Enter value for ${columns[$i]} (${types[$i]}): " value

            # Validate value based on type
            case "${types[$i]}" in
                int)
                    if [[ ! "$value" =~ ^[0-9]+$ ]]; then
                        echo "Invalid value for ${columns[$i]}. Expected an integer."
                        continue
                    fi
                    ;;
                float)
                    if [[ ! "$value" =~ ^[0-9]+\.[0-9]+$ ]]; then
                        echo "Invalid value for ${columns[$i]}. Expected a float."
                        continue
                    fi
                    ;;
                bool)
                    if [[ ! "$value" =~ ^(true|false)$ ]]; then
                        echo "Invalid value for ${columns[$i]}. Expected a boolean."
                        continue
                    fi
                    ;;
                string)
                    if [[ -z "$value" ]]; then
                        echo "Invalid value for ${columns[$i]}. Cannot be empty."
                        continue
                    fi
                    ;;
            esac

            row_data+=("$value")
            break
        done
    done

   

    # Ensure pk_index is set correctly
    if [ "$pk_index" -eq -1 ]; then
        echo "ERROR: Primary key index is not set properly!"
        return
    fi

    # Get the primary key value from the entered row
    pk_value="${row_data[$pk_index]}"

   

    # Check for duplicate primary key value
    if grep -q "^$pk_value " "$DB_DIR/$db_name/$table_name.data"; then
        echo "Error: Duplicate primary key value '$pk_value'."
        insert_into_table "$db_name"
        return
    fi

    # Insert the row data into the table's data file
    printf "%s\n" "${row_data[*]}" >> "$DB_DIR/$db_name/$table_name.data"
    echo "Row inserted successfully!"
}


 
           
   




Select_From_Table() {
    local db_name=$1
    read -p "Enter table name: " table_name

    
    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        echo "Table '$table_name' does not exist!"
        Select_From_Table
    fi

    
#    columns=()
#    pk_column=""
#    while read -r line; do
#        if [[ "$line" =~ ^PRIMARY_KEY:(.+)$ ]]; then
 #           pk_column="${BASH_REMATCH[1]}"
 #       else
#            columns+=("${line%%:*}")
 #       fi
  #  done < "$DB_DIR/$db_name/$table_name"

    columns=()
 #   types=()
    pk_column=""

    while read -r line; do
        name=$(echo $line | cut -d: -f1)
  #      type=$(echo $line | cut -d: -f2)

        if [[ "$name" == "PRIMARY_KEY" ]]; then
            pk_column="$type"
        else
            columns+=("$name")
  
        fi
    done < "$DB_DIR/$db_name/$table_name"

    
    if [ "${#columns[@]}" -eq 0 ]; then
        echo "Table '$table_name' has no columns defined."
       	Select_From_Table
    fi

    
    read -p "Enter value to search (leave empty to show all rows): " search_value

    
    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        echo "No data found for table '$table_name'"
        Select_From_Table
    fi

    
    echo "----------------------------------------"
    for col in "${columns[@]}"; do
        printf "%-15s" "$col"
    done
    echo
    echo "----------------------------------------"

    
    while read -r line; do
        if [ -z "$search_value" ] || [[ "$line" == "$search_value"* ]]; then
            echo "$line" | awk -v cols="${#columns[@]}" '
            {
                for (i = 1; i <= cols; i++) {
                    printf "%-15s", $i
                }
                print ""
            }'
        fi
    done < "$DB_DIR/$db_name/$table_name.data"

    echo "----------------------------------------"
    sleep 2
    db_menu "$db_name"
}
delete_from_table() {
    local db_name=$1
    read -p "Enter table name: " table_name

    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        echo "Table '$table_name' does not exist!"
        delete_from_table "$db_name"
        return
    fi

    # Read columns and types from the table definition
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

    # Ensure a primary key is defined
    if [ -z "$pk_column" ]; then
        echo "Error: No primary key defined for table '$table_name'."
        delete_from_table "$db_name"
        return
    fi

    # Ensure the .data file exists for storing rows
    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        echo "No data found for table '$table_name'"
        delete_from_table "$db_name"
        return
    fi

    echo "Enter the primary key value to delete: "
    read pk_value

    # Check if the primary key exists
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
        echo "Row with primary key '$pk_value' deleted successfully!"
    else
        echo "No row found with primary key '$pk_value'."
    fi

    read -p "Press any key to return to the database menu " 
    db_menu "$db_name"
}


update_table() {
    local db_name=$1
    read -p "Enter table name: " table_name

    # Check if the table exists
    if [ ! -f "$DB_DIR/$db_name/$table_name" ]; then
        echo "Table '$table_name' does not exist!"
        update_table "$db_name"
        return
    fi

    # Read columns and types from the table definition
    columns=()
    types=()
    pk_column=""
    pk_index=-1
    while read -r line; do
        name=$(echo $line | cut -d: -f1)
        type=$(echo $line | cut -d: -f2)

        if [[ "$name" == "PRIMARY_KEY" ]]; then
            pk_column="$type"
            pk_index=${#columns[@]}  # Set pk_index when PRIMARY_KEY is found
        else
            columns+=("$name")
            types+=("$type")
        fi
    done < "$DB_DIR/$db_name/$table_name"

    # Ensure a primary key is defined
    if [ -z "$pk_column" ]; then
        echo "Error: No primary key defined for table '$table_name'."
        update_table "$db_name"
        return
    fi

    # Ensure the .data file exists for storing rows
    if [ ! -f "$DB_DIR/$db_name/$table_name.data" ]; then
        echo "No data found for table '$table_name'"
        update_table "$db_name"
        return
    fi

    # Prompt for the primary key value to find the row
    read -p "Enter the primary key value to update: " pk_value

    # Search for the row with the given primary key
    row_to_update=""
    while read -r line; do
        row_pk_value=$(echo $line | cut -d' ' -f1)
        if [ "$row_pk_value" == "$pk_value" ]; then
            row_to_update="$line"
            break
        fi
    done < "$DB_DIR/$db_name/$table_name.data"

    # If the row doesn't exist, show an error
    if [ -z "$row_to_update" ]; then
        echo "Error: Row with primary key '$pk_value' not found."
        update_table "$db_name"
        return
    fi

    # Show the current data for the row
    echo "Current data for primary key '$pk_value':"
    echo "$row_to_update"

    # Prompt the user for which columns to update
    echo "Columns available for update:"
    for i in "${!columns[@]}"; do
        echo "$((i + 1))) ${columns[$i]} (${types[$i]})"
    done

    # Collect columns to update
    read -p "Enter column numbers to update (e.g., 1 2 3): " col_nums_input
    IFS=' ' read -r -a col_nums <<< "$col_nums_input"

    # Validate column numbers
    for col_num in "${col_nums[@]}"; do
        if [[ ! "$col_num" =~ ^[0-9]+$ ]] || [ "$col_num" -lt 1 ] || [ "$col_num" -gt "${#columns[@]}" ]; then
            echo "Invalid column number: $col_num."
            update_table "$db_name"
            return
        fi
    done

    # Collect new values for the selected columns
    new_values=()
    for col_num in "${col_nums[@]}"; do
        column_name="${columns[$((col_num - 1))]}"
        column_type="${types[$((col_num - 1))]}"

        while true; do
            read -p "Enter new value for $column_name ($column_type): " new_value

            # Validate the value based on the column type
            case "$column_type" in
                int)
                    if [[ ! "$new_value" =~ ^[0-9]+$ ]]; then
                        echo "Invalid value for $column_name. Expected an integer."
                        continue
                    fi
                    ;;
                float)
                    if [[ ! "$new_value" =~ ^[0-9]+\.[0-9]+$ ]]; then
                        echo "Invalid value for $column_name. Expected a float."
                        continue
                    fi
                    ;;
                bool)
                    if [[ ! "$new_value" =~ ^(true|false)$ ]]; then
                        echo "Invalid value for $column_name. Expected true or false."
                        continue
                    fi
                    ;;
                string)
                    if [[ -z "$new_value" ]]; then
                        echo "Invalid value for $column_name. Cannot be empty."
                        continue
                    fi
                    ;;
                *)
                    echo "Invalid column type."
                    return
                    ;;
            esac

            new_values+=("$new_value")
            break
        done
    done

    # Update the row with the new values
    updated_row="$row_to_update"
    for i in "${!col_nums[@]}"; do
        col_num=${col_nums[$i]}
        updated_row=$(echo "$updated_row" | awk -v col="$col_num" -v new_value="${new_values[$i]}" '{
            $col = new_value
            print
        }')
    done

    # Update the data file
    temp_file=$(mktemp)
    while read -r line; do
        row_pk_value=$(echo $line | cut -d' ' -f1)
        if [ "$row_pk_value" == "$pk_value" ]; then
            echo "$updated_row" >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$DB_DIR/$db_name/$table_name.data"

    # Replace the old data file with the updated one
    mv "$temp_file" "$DB_DIR/$db_name/$table_name.data"

    echo "Row updated successfully!"
    sleep 2
    db_menu "$db_name"
}
main_menu
