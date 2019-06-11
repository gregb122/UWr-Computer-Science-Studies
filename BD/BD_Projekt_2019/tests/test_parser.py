import pytest

from parser import Parser

TCS = {
    '{ "support": { "timestamp": 1557475701, "password": "123", "member": 3, "action":600, "project":5000}}':
        {'command': "support",
         'params': {"timestamp": 1557475701, "password": "123", "member": 3, "action": 600, "project": 5000}},
    '{}': {'command': "", 'params': {}}
}


@pytest.mark.parametrize('tc_parser_in', TCS)
def test_parsing_input(tc_parser_in):
    parser_in = Parser(tc_parser_in)
    assert parser_in.command == TCS[tc_parser_in]["command"]
    assert parser_in.params == TCS[tc_parser_in]["params"]
