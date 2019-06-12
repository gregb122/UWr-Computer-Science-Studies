import psycopg2

from parser import parse_result_as_json_object_to_output

SQL_FILE_NAME = 'db_model.sql'


def connect_with_db(dbname, user, password, host):
    try:
        conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host)
        curr = conn.cursor()
        return conn, curr
    except Exception as e:
        raise DbConnectionError(e)


def load_sql_into_db(conn, curr):
    with open(SQL_FILE_NAME, 'r') as f:
        curr.execute(f.read())
        conn.commit()


class DbConnectionError(Exception):
    def __init__(self, msg):
        self.msg = msg
