# Docker Postgres init scripts

Place any `.sql` files in this directory and they will be executed **once** when the container is first created. The default `docker-compose.yml` mounts this directory at `/docker-entrypoint-initdb.d` so that `postgres` will run them automatically.

Example workflow:

1. Design your schema in PgModeler → export as `01_schema.sql` to this folder.
2. (Optional) Add seed data in `02_seed.sql`.
3. Run `docker-compose up -d postgres` to start the database with schema & seed data loaded. 