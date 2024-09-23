from postgres:latest

env POSTGRES_USER=postgres
env POSTGRES_PASSWORD=root
env POSTGRES_DB=JeuNarratif

copy backup_db.pgsql /docker-entrypoint-initdb.d/

expose 5432
