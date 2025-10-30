"""Python script to connect to PostgreSQL, execute queries, and fetch results."""
import psycopg2
from psycopg2 import Error
from tabulate import tabulate

# Configuration for PostgreSQL connection
DATABASE = "postgres"
USER = "admin"
PASSWORD = "admin"
HOST = "127.0.0.1"
PORT = 5432


def create_connection():
    """Create a database connection to PostgreSQL"""
    try:
        connection = psycopg2.connect(
            database=DATABASE,
            user=USER,
            password=PASSWORD,
            host=HOST,
            port=PORT,
        )
        print("✅ Connection to PostgreSQL DB successful")
        return connection
    except Error as e:
        print(f"❌ Error connecting to PostgreSQL: {e}")
        return None


def execute_query(query):
    """Execute a query without returning a result"""
    with create_connection() as connection:
        if connection is None:
            print("⚠️ No connection available.")
            return
        try:
            with connection.cursor() as cursor:
                cursor.execute(query)
                connection.commit()
                print("✅ Query executed successfully")
        except Error as e:
            print(f"❌ Error executing query: {e}")


def execute_read_query(query):
    """Execute a SELECT query and return the result"""
    with create_connection() as connection:
        if connection is None:
            print("⚠️ No connection available.")
            return []
        try:
            with connection.cursor() as cursor:
                cursor.execute(query)
                result = cursor.fetchall()
                print("📦 Data fetched successfully")
                return result
        except Error as e:
            print(f"❌ Error executing SELECT: {e}")
            return []


if __name__ == "__main__":
    query = "SELECT * FROM customers;"
    rows = execute_read_query(query)

    if rows:
        # Get column names
        with create_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(query)
                column_names = [desc[0] for desc in cursor.description]

        # Display results in a table format
        print(tabulate(rows, headers=column_names, tablefmt="grid"))
        print(f"\nTotal rows fetched: {len(rows)}")
    else:
        print("⚠️ No data found.")
