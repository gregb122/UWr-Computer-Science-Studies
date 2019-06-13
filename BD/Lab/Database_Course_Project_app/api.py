from validator import *

from db_connector import connect_with_db


class Api:
    """
    This class is responsible for performing API function calls
    """

    def __init__(self, open_cmd):
        self.conn, self.curr = self.open(open_cmd)

        self.validator = Validator(conn=self.conn, curr=self.curr)
        self.api_helper = ApiHelper(conn=self.conn, curr=self.curr)

    def get_connection_and_cursor(self):
        return self.conn, self.curr

    def open(self, open_cmd):
        conn, curr = (
            connect_with_db(dbname=open_cmd["database"], user=open_cmd["login"], password=open_cmd["password"],
                            host='localhost'))
        return conn, curr

    def create_leader(self, params: dict):
        self.api_helper.add_new_member(params, member_type="L")

        self.conn.commit()

    def create_action(self, params, action_type):
        if self.api_helper.object_exists_in_db(table="Member", object="member_id", value=params["member"]):
            self.validator.validate(params, VERIFY_USER_STATUS, VERIFY_PASSWORD)
        else:
            self.api_helper.add_new_member(params)

        if params.get('authority', None):
            if not self.api_helper.object_exists_in_db(table="Project", object="authority_id",
                                                       value=params["authority"]):
                self.api_helper.add_new_index(params["authority"])

        if not self.api_helper.object_exists_in_db(table="Project", object="project_id", value=params["project"]):
            self.api_helper.add_new_project(params)

        self.api_helper.add_new_action(params, action_type)

        self.api_helper.update_member_status(params["member"], params["timestamp"])
        self.conn.commit()

    def make_vote(self, params, vote_type):
        self.validator.validate(params, VERIFY_USER_STATUS, VERIFY_PASSWORD, MEMBER_DID_NOT_VOTE_FOR_ACTION)

        self.api_helper.add_new_vote(params, vote_type)

        self.api_helper.update_member_status(params["member"], params["timestamp"])

        self.conn.commit()

    def list_projects(self, params):
        self.validator.validate(params, VERIFY_MEMBER_TYPE, VERIFY_USER_STATUS, VERIFY_PASSWORD)

        if params.get('authority', None):
            self.validator.validate({"table": "Project", "object": "authority_id", "value": params["authority"]},
                                    VERIFY_OBJECT_EXISTENCE)

        result = self.api_helper.get_projects(**params)

        self.api_helper.update_member_status(params["member"], params["timestamp"])

        self.conn.commit()
        return result

    def list_actions(self, params):
        self.validator.validate(params, VERIFY_MEMBER_TYPE, VERIFY_USER_STATUS, VERIFY_PASSWORD)

        if params.get('authority', None):
            self.validator.validate({"table": "Project", "object": "authority_id", "value": params["authority"]},
                                    VERIFY_OBJECT_EXISTENCE)

        if params.get('project', None):
            self.validator.validate({"table": "Project", "object": "project_id", "value": params["project"]},
                                    VERIFY_OBJECT_EXISTENCE)

        result = self.api_helper.get_actions(**params)

        self.api_helper.update_member_status(params["member"], params["timestamp"])

        self.conn.commit()
        return result

    def list_votes(self, params):
        self.validator.validate(params, VERIFY_MEMBER_TYPE, VERIFY_PASSWORD, VERIFY_USER_STATUS)

        if params.get('action', None):
            self.validator.validate({"table": "Action", "object": "action_id", "value": params["action"]},
                                    VERIFY_OBJECT_EXISTENCE)

        # check if project was provided
        if params.get('project', None):
            self.validator.validate({"table": "Project", "object": "project_id", "value": params["project"]},
                                    VERIFY_OBJECT_EXISTENCE)

        result = self.api_helper.get_votes(**params)

        self.api_helper.update_member_status(params["member"], params["timestamp"])

        self.conn.commit()
        return result

    def list_trolls(self, params):
        self.api_helper.update_all_members_status(params["timestamp"])
        self.conn.commit()

        self.curr.execute("SELECT * FROM Troll WHERE downvote - upvote > 0 ORDER BY downvote - upvote")
        result = self.curr.fetchall()
        self.conn.commit()
        return result


class ApiHelper:
    """
    This class contains all operations used by Api class
    """

    def __init__(self, conn, curr):
        self.conn = conn
        self.curr = curr
        self.validator = Validator(conn=conn, curr=curr)

    def object_exists_in_db(self, table, object, value):
        self.curr.execute(
            'SELECT * FROM {table} WHERE {object}={value}'.format(table=table, object=object, value=value))
        if not self.curr.fetchall():
            return False
        return True

    def add_new_index(self, index_id):
        self.validator.validate({"table": "Index", "object": "index_id", "value": index_id}, VERIFY_OBJECT_DUPLICATION)
        self.curr.execute('INSERT INTO Index VALUES (%s)', (index_id,))

    def add_new_member(self, params, member_type="M"):
        self.validator.validate({"table": 'Member', "object": "member_id", "value": params["member"]},
                                VERIFY_OBJECT_DUPLICATION)
        self.add_new_index(params['member'])
        self.curr.execute(
            "INSERT INTO Member VALUES (%s, crypt(%s, gen_salt('bf')), %s, %s)", (params['member'], params["password"],
                                                                                  params['timestamp'], member_type)
        )
        self.curr.execute("INSERT INTO Troll(member_id) VALUES (%s)", (params["member"], ))

    def add_new_action(self, params, action_type):
        self.validator.validate({"table": "Action", "object": "action_id", "value": params["action"]},
                                VERIFY_OBJECT_DUPLICATION)
        self.add_new_index(params["action"])
        self.curr.execute("INSERT INTO Action VALUES ({}, {}, {}, '{}', {})".format(
            params['action'], params.get('authority', 'NULL'), params['project'], action_type, params['member']))

    def add_new_project(self, params):
        if not params.get('authority', None):
            self.validator.validate({"msg": "Authority value must be passed!"}, THROW_EXCEPTION)

        self.validator.validate({"table": 'Project', "object": "project_id", "value": params["project"]},
                                VERIFY_OBJECT_DUPLICATION)

        self.add_new_index(params['project'])

        self.curr.execute('INSERT INTO Project VALUES (%s, %s)', (params['project'], params["authority"], ))

    def add_new_vote(self, params, vote_type):
        self.validator.validate({"table": "Action", "object": "action_id", "value": params["action"]},
                                VERIFY_OBJECT_EXISTENCE)

        self.curr.execute("INSERT INTO Vote VALUES (%s, %s, %s)", (params["member"], params["action"],
                                                                          "Y" if vote_type == "upvote"
                                                                          else "N"))
        self.curr.execute(
            "UPDATE Troll SET {vote_type} = {vote_type} + 1 WHERE member_id={member}".format(vote_type=vote_type,
                                                                                             member=params["member"]))

    def update_member_status(self, user, timestamp, command=""):
        self.curr.execute("SELECT last_activity FROM Member WHERE member_id=%s", (user, ))
        previous_action_timestamp = self.curr.fetchall()[0][0]
        if timestamp - previous_action_timestamp > YEAR_IN_SECONDS:
            self.curr.execute("UPDATE Troll SET active = false WHERE member_id=%s", (user, ))
        if command != "trolls":
            self.curr.execute("UPDATE Member SET last_activity=%s WHERE member_id=%s", (timestamp, user, ))

    def update_all_members_status(self, timestamp):
        self.curr.execute("SELECT member_id FROM Member")
        for member in self.curr.fetchall():
            self.update_member_status(member[0], timestamp, command="trolls")

    def get_projects(self, authority="", **kwargs):
        authority = "WHERE authority_id={}".format(str(authority)) if authority else authority
        self.curr.execute("SELECT * FROM Project " + authority + "ORDER BY project_id")
        return self.curr.fetchall()

    def get_actions(self, type="", project="", authority="", **kwargs):
        where = "WHERE " if type or project or authority else ""
        authority = "authority_id={}".format(str(authority)) if authority else authority
        project = "project_id={}".format(str(project)) if project else project
        type = "action_type='{}'".format(type) if type else type

        query = 'SELECT Action.action_id, Action.action_type, Action.project_id, Action.authority_id, SUM(CASE WHEN ' \
                'Vote.vote_type=\'Y\' THEN 1 ELSE 0 END) AS upvotes, SUM(CASE WHEN Vote.vote_type=\'N\' THEN 1 ELSE 0 '\
                'END) AS downvotes FROM Action JOIN Vote USING(action_id) '

        added_elems = 0
        for elem in [where, authority, project, type]:
            if elem:
                if added_elems < 2:
                    query += elem
                else:
                    query += " AND " + elem
                added_elems += 1

        query += 'GROUP BY Action.action_id ORDER BY action_id; '

        self.curr.execute(query)

        return self.curr.fetchall()

    def get_votes(self, action="", project="", **kwargs):
        action = "WHERE action_id={}".format(str(action)) if action else action
        project = "WHERE project_id={}".format(str(project)) if project else project
        self.curr.execute(
            'SELECT Member.member_id, SUM(CASE WHEN Vote.vote_type=\'Y\' THEN 1 ELSE 0 END) AS upvotes, '
            'SUM(CASE WHEN Vote.vote_type=\'N\' THEN 1 ELSE 0 '
            'END) AS downvotes FROM Member LEFT JOIN Vote USING(member_id) LEFT JOIN Action USING(action_id) LEFT '
            'JOIN Project '
            'USING(project_id) ' + action + project + 'GROUP BY Member.member_id ORDER BY member_id;')

        return self.curr.fetchall()
