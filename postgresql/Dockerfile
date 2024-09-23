from postgres:latest

env POSTGRES_USER=postgres
env POSTGRES_PASSWORD=RooT1234
#index.js dockercompose à changer uassi
env POSTGRES_DB=JeuNarratif

run mkdir /var/dump
WORKDIR /var/dump

copy backup_db.pgsql /var/dump/ 
copy init.sh /docker-entrypoint-initdb.d/ 
RUN chown postgres:postgres /docker-entrypoint-initdb.d/init.sh

#expose 5432
