import subprocess

def import_sql_dump(database_name, dump_file):
    try:
        # Command to import the SQL dump into MySQL
        command = ["mysql", "-u", "username", "-p", "password", "-h", "localhost", database_name]
        
        # Read the dump file and pipe it to the mysql command
        with open(dump_file, 'rb') as f:
            subprocess.run(command, stdin=f, check=True)
        
        print("Database import successful!")
    except subprocess.CalledProcessError as e:
        print("Error:", e)

def main():
    # Take user input for database name
    database_name = input("Enter the name of the MySQL database: ")

    # Take user input for the path to the SQL dump file
    dump_file = input("Enter the path to the SQL dump file: ")

    # Call the function to import the SQL dump
    import_sql_dump(database_name, dump_file)

if __name__ == "__main__":
    main()
