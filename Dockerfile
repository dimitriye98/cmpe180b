FROM mysql:9.1

COPY ./init /docker-entrypoint-initdb.d/
