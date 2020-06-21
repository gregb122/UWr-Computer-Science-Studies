import sys
import argparse

from termcolor import colored

from parser import ArgumentError
from api import Api
from db_connector import connect_with_db, load_sql_into_db
from validator import CustomException
from parser import parse_json_object, parse_result_as_json_object_to_output, read_json_objects_from_file


def main():
    """
    Main function responsible for capture stdin and running program with following terminal switches:
    --reset - Clears database schema and content
    --init - Initialization mode - Creates database structure (tables, constraints, etc.) and app user with granting
    privileges. Loads also leaders into database
    (--)default, with no switches: Execute list of api calls JSON lists
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("--init", action='store_true')
    parser.add_argument("--reset", action='store_true')
    args, _ = parser.parse_known_args()

    if args.reset:
        reset()
    else:
        stdin = read_json_objects_from_file(sys.stdin)
        if args.init:
            run(stdin, init=True)
        else:
            run(stdin)


def run(std_in, init=False):
    """
    Execute all queries except first (with open) from stdin
    :param std_in: json objects separated by line ending symbol
    :param init: switch for disable/enable initialization mode
    """
    api, result = connect(std_in[0])
    if api is None:
        print(colored(result, 'red'))
        return
    print(result)
    if init:
        conn, curr = api.get_connection_and_cursor()
        load_sql_into_db(conn, curr)

    for api_call in std_in[1:]:
        try:
            command, params = parse_json_object(api_call)
            print(run_api_function(api, command, params))
        except CustomException if init else (CustomException, ArgumentError) as e:
            print(colored(parse_result_as_json_object_to_output(result=str(e), failed=True), 'red'))

    conn, curr = api.get_connection_and_cursor()
    curr.close()
    conn.close()


def connect(line_open):
    """
    Open connection with database
    :param line_open: first line of stdin (query with 'open' command)
    :return: Api object with open connection if success, None if failed
    """
    _, open_cmd = parse_json_object(line_open)
    try:
        api = Api(open_cmd)
        return api, parse_result_as_json_object_to_output("")
    except Exception as e:
        return None, parse_result_as_json_object_to_output(result=str(e), failed=True)


def run_api_function(api, command, params):
    """
    Execute single query parsed from stdin
    :param api: object with open connection, responsible for performing action query
    :param command: name of the action query
    :param params: parameters for the action query
    :return: JSON object with data results
    """
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
    """
    Reset database: recreate schema and drop user
    """
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


if __name__ == '__main__':
    main()
