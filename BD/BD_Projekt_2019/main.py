import sys
import argparse

from termcolor import colored

from api import Api
from db_connector import connect_with_db, load_sql_into_db, DbConnectionError
from validator import CustomException
from parser import parse_json_object, parse_result_as_json_object_to_output, read_json_objects_from_file


def run_init(std_in):
    _, open_cmd = parse_json_object(std_in[0])

    try:
        api = Api(open_cmd)
    except DbConnectionError as e:
        print(colored(parse_result_as_json_object_to_output(result=str(e), failed=True), 'red'))
        sys.exit(1)

    conn, curr = api.get_connection_and_cursor()
    load_sql_into_db(conn, curr)

    for line in std_in[1:]:
        command, params = parse_json_object(line)
        try:
            print(run_api_function(api, command, params))
        except CustomException as e:
            print(colored(parse_result_as_json_object_to_output(result=str(e), failed=True), 'red'))


def run_app(std_in):
    _, open_cmd = parse_json_object(std_in[0])
    api = Api(open_cmd)

    for api_call in std_in[1:]:
        command, params = parse_json_object(api_call)
        try:
            print(run_api_function(api, command, params))
        except CustomException as e:
            print(colored(parse_result_as_json_object_to_output(result=str(e), failed=True), 'red'))


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
    if command == "leader":
        api.create_leader(params)
    if command == "open":
        api.open(params)

    return parse_result_as_json_object_to_output(api_out)


def reset():
    conn, curr = connect_with_db(dbname="student", user="init", password="qwerty", host='localhost')
    curr.execute('DROP SCHEMA public CASCADE')
    curr.execute('CREATE SCHEMA public')
    curr.execute('GRANT ALL ON SCHEMA public TO postgres')
    curr.execute('GRANT ALL ON SCHEMA public TO public')
    curr.execute('DROP OWNED BY app')
    curr.execute('DROP ROLE app')
    conn.commit()
    curr.close()
    conn.close()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--init")
    parser.add_argument("--reset", action='store_true')
    args, _ = parser.parse_known_args()

    if args.init:
        std_in = read_json_objects_from_file(sys.argv[2])
        run_init(std_in)
    elif args.reset:
        reset()
    else:
        std_in = read_json_objects_from_file(sys.argv[1])
        run_app(std_in)


if __name__ == '__main__':
    main()
