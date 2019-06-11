import pytest
import psycopg2

from api import Api

TEST_DB_NAME = 'test_student'
TEST_USER = 'test_app'
TEST_PASSWORD = 'qwerty'

SUPPORT = [
    # Member create new support action, he does not exists before
    ('{"support": {"timestamp": 1557475701, "password": "123", "member": 3, "action": 600, "project": 5000}}',
     '{"status": "OK}'
    ),

    '{"support": {"timestamp": 1557475701, "password": "abc", "member": 1, "action": 601, "project": 5001, \
                 "authority": 10000}}',
    '{"support": {"timestamp": 1557475701, "password": "abc", "member": 1, "action": 602, "project": 5002, \
                 "authority": 10001}}',

    '{"support": {"timestamp": 1557475701, "password": "cztery", "member": 4, "action": 700, "project": 5000}}',

]

@pytest.fixture(scope='module')
def api():
    test_conn = psycopg2.connect(dbname=TEST_DB_NAME, user=TEST_USER, password=TEST_PASSWORD, host='localhost')
    test_curr = test_conn.cursor()

    return Api(conn=test_conn, curr=test_curr)

@pytest.mark.parametrize('support', SUPPORT)
def test_support(support):
    pass
