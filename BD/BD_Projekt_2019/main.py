from termcolor import colored

from api import *
from parser import *

from tests import APP, INIT


def initialize(std_in):
    reset()
    conn = psycopg2.connect(dbname="student", user="init", password="qwerty", host='localhost')
    curr = conn.cursor()

    curr.execute(open('db_model.sql', 'r').read())
    conn.commit()

    api = Api(conn=conn, curr=curr)
    for line in std_in[1:]:
        print(line)
        _, params = parse_json_object_from_input(line)
        api.create_leader(params)

    curr.close()
    conn.close()


def reset():
    conn = psycopg2.connect(dbname="student", user="init", password="qwerty", host='localhost')
    curr = conn.cursor()
    curr.execute('DROP SCHEMA public CASCADE')
    curr.execute('CREATE SCHEMA public')
    curr.execute('GRANT ALL ON SCHEMA public TO postgres')
    curr.execute('GRANT ALL ON SCHEMA public TO public')
    curr.execute('DROP OWNED BY app')
    curr.execute('DROP ROLE app')
    conn.commit()
    curr.close()
    conn.close()


def run_app(std_in):
    conn = psycopg2.connect(dbname="student", user="app", password="qwerty", host='localhost')
    curr = conn.cursor()

    api = Api(conn=conn, curr=curr)

    for api_call in std_in:
        print(api_call)
        command, params = parse_json_object_from_input(api_call)
        try:
            run_api_function(api, command, params)
        except CustomException as e:
            print(colored(str(e), 'red'))


def run_api_function(api, command, params):
    api_out = ""
    if command in ('support', 'protest'):
        api.create_action(params, command)
    if command in ('upvote', 'downvote'):
        api.make_vote(params, command)
    if command == 'projects':
        api_out = api.list_projects(params)
    if command == "actions":
        api_out = api.list_actions(params)
    if command == "votes":
        api_out = api.list_votes(params)
    if command == "trolls":
        api_out = api.list_trolls(params)

    return parse_result_as_json_object_to_output(api_out)


initialize(INIT)
run_app(APP)
