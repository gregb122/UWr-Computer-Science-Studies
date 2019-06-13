# How to run this app:
1. Before running app, following preparations in PostgreSQL should be provided:
> psql postgres
> CREATE DATABASE student;
> CREATE USER init WITH ENCRYPTED PASSWORD "qwerty";
> ALTER USER init WITH SUPERUSER;
> GRANT CONNECT ON DATABASE student TO init;
2. Activate virtual env (e.g. source dst_venv/bin/activate)
3. Run app with example commands:
> cat stdin_test_data/negative_init.json | python main.py --init
> cat stdin_test_data/positive_init.json | python main.py --init
> cat stdin_test_data/positive_calls.json | python main.py
> cat stdin_test_data/negative_calls.json | python main.py
4. Reset database:
> python main.py --reset


# How to test this app:
1. Before running tests, following preparations in PostgreSQL should be provided:
> CREATE DATABASE test_student;
> CREATE USER test_init WITH ENCRYPTED PASSWORD "qwerty"
> ALTER USER test_init WITH SUPERUSER;
> GRANT CONNECT ON DATABASE test_student TO test_init;
2. With active virtual env in project directory (../../Database_Course_Project_app run:
> pytest
