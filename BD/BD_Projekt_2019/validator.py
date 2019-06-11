import psycopg2

YEAR_IN_SECONDS = 3600 * 24 * 365 + 3600 * 5 + 48 * 60  # 31556880

VERIFY_PASSWORD = 'verify_password'
VERIFY_USER_STATUS = 'verify_user_status'
MEMBER_DID_NOT_VOTE_FOR_ACTION = 'member_did_not_vote_for_action'
VERIFY_OBJECT_DUPLICATION = 'verify_object_duplication'
VERIFY_OBJECT = 'verify_object'
THROW_EXCEPTION = 'throw_exception'


class Validator:
    """
    Possible commands:
    1. verify_password
    """
    def __init__(self, conn, curr):
        self.conn = conn
        self.curr = curr

    def validate(self, params, *commands):
        for command in commands:
            eval("self." + command + "({args})".format(args=params))

    def verify_password(self, params):
        self.curr.execute("SELECT * FROM Member WHERE member_id={} AND password='{}'".format(params["member"], params["password"]))
        if not self.curr.fetchall():
            raise CustomException("Wrong password for {}, authentication failed!".format(params["member"]))

    def verify_user_status(self, params):
        self.curr.execute("SELECT last_activity FROM Member WHERE member_id={}".format(params["member"]))

        previous_action_timestamp = self.curr.fetchall()[0][0]
        if params["timestamp"] - previous_action_timestamp > YEAR_IN_SECONDS:
            raise CustomException("User {} cannot perform any operations!".format(params["member"]))

    def verify_object(self, params):
        self.curr.execute('SELECT * FROM {table} WHERE {object}={value}'.format(table=params["table"], object=params["object"], value=params["value"]))
        if not self.curr.fetchall():
            raise CustomException("{object} is not exists in {table} table!".format(object=params["object"], table=params["table"]))

    def member_did_not_vote_for_action(self, params):
        self.curr.execute('SELECT * FROM Vote WHERE member_id={user} AND action_id={action}'.format(user=params["member"], action=params["action"]))
        if self.curr.fetchall():
            raise CustomException("You cannot vote for the same action twice!")

    def verify_object_duplication(self, params):
        self.curr.execute(
            'SELECT * FROM {table} WHERE {object}={value}'.format(table=params["table"], object=params["object"],
                                                                  value=params["value"]))
        if self.curr.fetchall():
            raise CustomException("{object} already exists in {table} table!".format(object=params["object"], table=params["table"]))

    def throw_exception(self, msg):
        raise CustomException(msg["msg"])


class CustomException(Exception):
    def __init__(self, msg):
        self.msg = msg
