## 0. Install PostgreSQL via Homebrew
```bash
# install the binary
$ brew install postgresql

# init it
$ initdb /usr/local/var/postgres

# start the postgres server
$ postgres -D /usr/local/var/postgres
```

## 1. Generate xcode project and open it
##### <b>Directory:</b> test-example/
Execute in your command line
```bash
$ vapor xcode -y
```

## 2. Set your database configuration
##### <b>File:</b> test-example/Config/secrets/postgresql.json
Change my user `martinlasek` to yours and choose a database name
```JSON
{
  "hostname": "127.0.0.1",
  "user": "martinlasek",
  "password": "",
  "database": "testexample",
  "port": 5432
}
```

## 3. Create the database
##### <b>Directory:</b> <i>doesn't matter</i>
Execute in your command line
```bash
$ createdb testexample;
```
