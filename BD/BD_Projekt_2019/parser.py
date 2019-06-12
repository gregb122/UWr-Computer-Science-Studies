import json

from typing import Tuple


def read_json_objects_from_file(f_name):
    json_objects = []
    with open(f_name, 'r') as f:
        for line in f:
            if line.startswith('{'):
                json_objects.append(line.replace("\n", ""))
    return json_objects


def parse_json_object(std_in: str) -> Tuple[str, dict]:
        std_in = json.loads(std_in)
        try:
            command = list(std_in.keys())[0]
            return command, std_in[command]
        except (KeyError, IndexError) as e:
            print("Wrong input json format: {}".format(e))
            return "", {}


def parse_result_as_json_object_to_output(result, failed=False):
        std_out = {"status": "OK"} if not failed else {"status": "ERROR", "debug": result}
        if result and not failed:
            std_out["data"] = result
        return json.dumps(std_out)


def validate_signature(command, params):
    pass
