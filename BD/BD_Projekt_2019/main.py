import sys
import argparse

from termcolor import colored

from parser import ArgumentError
from api import Api
from db_connector import connect_with_db, load_sql_into_db
from validator import CustomException
from parser import parse_json_object, parse_result_as_json_object_to_output, read_json_objects_from_file


def run_init(std_in):
    api, result = run_open(std_in[0])
    if api is None:
        print(colored(result, 'red'))
        return
    print(result)

    conn, curr = api.get_connection_and_cursor()
    load_sql_into_db(conn, curr)

    for line in std_in[1:]:
        try:
            command, params = parse_json_object(line)
            print(run_api_function(api, command, params))
        except CustomException as e:
            print(colored(parse_result_as_json_object_to_output(result=str(e), failed=True), 'red'))


def run_app(std_in):
    api, result = run_open(std_in[0])

    if api is None:
        print(colored(result, 'red'))
        return

    print(result)
    for api_call in std_in[1:]:
        try:
            command, params = parse_json_object(api_call)
            print(run_api_function(api, command, params))
        except (CustomException, ArgumentError) as e:
            print(colored(parse_result_as_json_object_to_output(result=str(e), failed=True), 'red'))


def run_open(line_open):
    _, open_cmd = parse_json_object(line_open)
    try:
        api = Api(open_cmd)
        return api, parse_result_as_json_object_to_output("")
    except Exception as e:
        return None, parse_result_as_json_object_to_output(result=str(e), failed=True)


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
    parser.add_argument("--init", action='store_true')
    parser.add_argument("--reset", action='store_true')
    args, _ = parser.parse_known_args()

    if args.init:
        stdin = read_json_objects_from_file(sys.stdin)
        run_init(stdin)
    elif args.reset:
        reset()
    else:
        stdin = read_json_objects_from_file(sys.stdin)
        run_app(stdin)


if __name__ == '__main__':
    main()
