import json


def read_json_objects_from_file(io_textwrapper):
    json_objects = []
    for line in io_textwrapper:
        if line.startswith('{'):
            json_objects.append(line.replace("\n", ""))
    return json_objects


def parse_json_object(std_in):
        std_in = json.loads(std_in)
        command = list(std_in.keys())[0]
        params = std_in[command]
        validate_signature(command, params)
        return command, params


def parse_result_as_json_object_to_output(result, failed=False):
        std_out = {"status": "OK"} if not failed else {"status": "ERROR", "debug": result}
        if result and not failed:
            std_out["data"] = result
        return json.dumps(std_out)


def validate_signature(command, params):
    if command == "votes":
        if params.get("action", None) and params.get("project", None):
            raise ArgumentError("Too many arguments: action, project were provided")
    elif command == "actions":
        if params.get("authority", None) and params.get("project", None):
            raise ArgumentError("Too many arguments: action, authority were provided")


class ArgumentError(Exception):
    def __init__(self, msg):
        self.msg = msg
