Initial setup:
```
docker build --progress=plain -t salesdb .
docker network create -d bridge salesdb
docker run -d --name salesdb -e MYSQL_ROOT_PASSWORD=root --network salesdb -v DIRECTORY_TO_STORE_DB_FILES:/var/lib/mysql salesdb
```

Connect to DB with:
```
docker run -it --rm --network salesdb mysql mysql -h salesdb -u root -p
```
