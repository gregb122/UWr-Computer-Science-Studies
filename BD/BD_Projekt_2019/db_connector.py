import psycopg2

SQL_FILE_NAME = 'db_model.sql'


def connect_with_db(dbname, user, password, host):
    conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host)
    curr = conn.cursor()
    return conn, curr


def load_sql_into_db(conn, curr):
    with open(SQL_FILE_NAME, 'r') as f:
        curr.execute(f.read())
        conn.commit()

