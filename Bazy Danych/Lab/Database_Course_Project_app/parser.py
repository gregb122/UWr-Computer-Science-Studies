import json


def read_json_objects_from_file(io_textwrapper):
    """
    Parse stdin into list of jsons; filter all remain non-json data
    :param io_textwrapper: IOTextWrapper instance (obtained from sys.stdin)
    :return: List of strings with json objects
    """
    json_objects = []
    for line in io_textwrapper:
        if line.startswith('{'):
            json_objects.append(line.replace("\n", ""))
    return json_objects


def parse_json_object(std_in_line):
    """
    Parse single JSON object and extract it into command, params
    :param std_in_line: single JSON object represented as string
    :return: command = name of action query, params = dict parameters of action query
    """
    std_in_line = json.loads(std_in_line)
    command = list(std_in_line.keys())[0]
    params = std_in_line[command]
    validate_signature(command, params)
    return command, params


def parse_result_as_json_object_to_output(result, failed=False):
    """
    Parse result returned by action query Api function into JSON
    :param result: List of lists with data result (only for successful action)
    :param failed: pass/fail execution api function flag
    :return: specified JSON object (see project documentation for more details)
    """
    std_out = {"status": "OK"} if not failed else {"status": "ERROR", "debug": result}
    if result and not failed:
        std_out["data"] = result
    return json.dumps(std_out)


def validate_signature(command, params):
    """
    Validate input JSON object if has legal combination of optional arguments (see project
    documentation for more details)
    :param command: name of action query
    :param params: parameters of action query
    :return: raise ArgumentError if illegal combination of optional arguments is detected
    """
    if command == "votes":
        if params.get("action", None) and params.get("project", None):
            raise ArgumentError("Too many arguments: action, project were provided")
    elif command == "actions":
        if params.get("authority", None) and params.get("project", None):
            raise ArgumentError("Too many arguments: action, authority were provided")


class ArgumentError(Exception):
    def __init__(self, msg):
        self.msg = msg
