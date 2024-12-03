# SalesDB
## Introduction
- This Project aims to create a MySQL database that can be used to track purchase & sales data for a web-based store
  - The database supports products with a diverse range of categories & properties
  - Currently, the databse is populated with electronics and clothings
- Developed for SJSU CMPE 180B semester project.
## Project Setup
### Initial setup:
- Install docker on the machine
- Initialize the docker image with:
```
docker build --progress=plain -t salesdb .
docker network create -d bridge salesdb
docker run -p 3307:3306 -d --name salesdb -e MYSQL_ROOT_PASSWORD=root --network salesdb -v DIRECTORY_TO_STORE_DB_FILES:/var/lib/mysql salesdb
```
- Note: this maps the mysql database to port 3307 on the local host to avoid clashing with local mysql installations

### Connect to DB with:
```
docker run -it --rm --network salesdb mysql mysql -h salesdb -u root -p
```

### Add triggers
```
TODO
```

### Populate the database:
- The database is automatically populated when building the docker image
- If the database is manually populated, use the following code:
```
TODO
```

## Database Optimization
### Adding Indexes
```
TODO
```

### Optimization results
```
TODO
```

## Executing Queries
- See `queries.sql` for details

## Test Cases
- See `database_test.md` for details

## Backup & Recovery
- Performed with mysqldump command
- To back up directly from the docker image:
  - This will create a `dump.sql` file in the current directory
```
docker exec -i salesdb mysqldump -uroot -proot --databases SalesDB --skip-comments > ./dump.sql
```
- Preferred way of recovery: rebuild the docker image
  1. Remove the files in /init folder and replace with `dump.sql`
  2. Remove the created volumes and images in docker
  3. Call the 3 steps in initial setup to rebuild and docker image and recreate the container

- Alternative way of recovery: importing the dumpfile through docker CLI
  - Make sure that `dump.sql` is in the current directory
  - May lead to errors suck as `socket.error: [Errno 32] Broken pipe` and `ValueError: file descriptor cannot be a negative integer (-1)`
```
docker exec salesdb /bin/bash -c 'mysql -uroot -proot < ./dump.sql'
```
