# import mysql.connector
#
# # MySQL Database configuration
# db_config = {
#     "host": "localhost",
#     "user": "root",
#     "password": "root",
#     "database": "studentdb"
# }
#
# def execute_query(sql_query):
#     """Execute a SQL query and fetch results."""
#     connection = mysql.connector.connect(**db_config)
#     cursor = connection.cursor()
#     cursor.execute(sql_query)
#     result = cursor.fetchall()
#     cursor.close()
#     connection.close()
#     return result

import mysql.connector

def execute_query(query: str, return_columns=False):
    # Connect to your database
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="studentdb"
    )
    cursor = connection.cursor()

    cursor.execute(query)
    result = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]  # Get column names

    cursor.close()
    connection.close()

    if return_columns:
        return result, columns
    return result
