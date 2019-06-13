import psycopg2

SQL_FILE_NAME = 'db_model.sql'


def connect_with_db(dbname, user, password, host):
    """
    :param dbname: name of existing database in psql
    :param user: name of existing user in psql who has access for above dbname
    :param password: psql valid password for above user
    :param host: Address of database localization
    :return: psycopg2 connector object, psycopg2 curser object
    """
    conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host)
    curr = conn.cursor()
    return conn, curr


def load_sql_into_db(conn, curr):
    """
    :param conn: psycopg2 connector object
    :param curr: psycopg2 cursor object
    """
    with open(SQL_FILE_NAME, 'r') as f:
        curr.execute(f.read())
        conn.commit()

