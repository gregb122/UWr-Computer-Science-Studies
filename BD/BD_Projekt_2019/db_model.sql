CREATE DOMAIN ACTION_TYPE AS varchar
CHECK(
    VALUE IN ('support', 'protest')
     );

CREATE DOMAIN VOTE_TYPE AS varchar
CHECK
    (
    VALUE IN ('Y', 'N')
    );

CREATE DOMAIN MEMBER_TYPE AS varchar
CHECK(
    VALUE IN ('M', 'L')
    );

CREATE TABLE Index (
    index_id integer primary key
);

CREATE TABLE Member (
    member_id integer primary key,
    password varchar(128) not null,
    last_activity integer not null,
    member_type MEMBER_TYPE not null DEFAULT 'M'
);

CREATE TABLE Action (
    action_id integer primary key,
    authority_id integer,
    project_id integer,
    action_type ACTION_TYPE,
    action_creator_id integer not null
);

CREATE TABLE Vote (
    member_id integer,
    action_id integer,
    vote_type VOTE_TYPE,
    primary key (member_id, action_id)
);

CREATE TABLE Project (
    project_id integer primary key,
    authority_id integer
);

CREATE TABLE Troll (
    member_id integer primary key,
    upvote integer default 0,
    downvote integer default 0,
    active bool default false
);


ALTER TABLE Member
ADD CONSTRAINT fk_member_id_index_id FOREIGN KEY (member_id) REFERENCES Index(index_id) ON DELETE CASCADE;

ALTER TABLE Action
ADD CONSTRAINT fk_action_id_index_id FOREIGN KEY (action_id) REFERENCES Index(index_id) ON DELETE CASCADE,
ADD CONSTRAINT authority_id_index_id FOREIGN KEY (authority_id) REFERENCES Index(index_id) ON DELETE CASCADE,
ADD CONSTRAINT fk_project_id_project_id FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE;

ALTER TABLE Project
ADD CONSTRAINT fk_project_id_index_id FOREIGN KEY (project_id) REFERENCES Index(index_id) ON DELETE CASCADE;

ALTER TABLE Vote
ADD CONSTRAINT fk_member_id_member_id FOREIGN KEY (member_id) REFERENCES Member(member_id) ON DELETE CASCADE,
ADD CONSTRAINT fk_action_id_action_id FOREIGN KEY (action_id) REFERENCES Action(action_id) ON DELETE CASCADE;

ALTER TABLE Troll
ADD CONSTRAINT fk_member_id_action_creator_id FOREIGN KEY (member_id) REFERENCES Member(member_id) ON DELETE CASCADE;

CREATE ROLE app WITH encrypted password 'qwerty';
ALTER ROLE app WITH LOGIN;
GRANT CONNECT ON DATABASE student TO app;

GRANT INSERT, UPDATE, SELECT ON Troll, Action, Member, Index, Vote, Project TO app;
