import json

from typing import Tuple


def parse_json_object_from_input(std_in: str) -> Tuple[str, dict]:
        std_in = json.loads(std_in)
        try:
            command = list(std_in.keys())[0]
            return command, std_in[command]
        except (KeyError, IndexError) as e:
            print("Wrong input json format: {}".format(e))
            return "", {}


def parse_result_as_json_object_to_output(result):
        std_out = {"status": "OK"}
        if result:
            std_out["data"] = result
        return json.dumps(std_out)
