#!/bin/bash

# MySQL database connection details
DB_HOST="localhost"
DB_USER="root"
DB_PASS="hacker"
DB_NAME="crosstrax"

# Path to the SQL dump file
SQL_DUMP_FILE="/opt/omniscient/crosstrax_new_llm_hacked/crosstrax_ai_hacked_sql_db.sql"

# Check if the SQL dump file exists
if [ ! -f "$SQL_DUMP_FILE" ]; then
    echo "Error: SQL dump file not found at $SQL_DUMP_FILE"
    exit 1
fi

# Import the SQL dump file into the database
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_DUMP_FILE"

# Check the exit status of the mysql command
if [ $? -eq 0 ]; then
    echo "Database import successful!"
else
    echo "Error: Database import failed"
    exit 1
fi
