# AUTH (Authentication and Authorization)

## Environment
System Requirements | Version |  | Used Packages | Version |
------------ | ------------- | ------------- | ------------- | ------------- |
macOS | Sierra |  | vapor | 2.1 |
swift | 3.1 |  | postgresql-provider | 2.x |
vapor-toolbox | 2.0.3 | | fluent-provider | 1.x |
postgreSQL | 9.6.x | | auth-provider | 1.x |
| | | leaf-provider | 1.x |

<center>- TESTED AND ASSURED TO WORK WITH ABOVE VERSIONS - </center>

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
##### <b>Directory:</b> crud-example/
Execute in your command line
```bash
$ vapor xcode -y
```

## 2. Set your database configuration
##### <b>File:</b> crud-example/Config/secrets/postgresql.json
Change my user `martinlasek` to yours and choose a database name
```JSON
{
  "hostname": "127.0.0.1",
  "user": "martinlasek",
  "password": "",
  "database": "authexample",
  "port": 5432
}
```

## 3. Create the database
##### <b>Directory:</b> <i>doesn't matter</i>
Execute in your command line
```bash
$ createdb authexample;
```

## 4. Build and Run
##### <b>Application:</b> Xcode
Make sure before you hit the ► button, that you selected <b> Run </b> Scheme to the right of the button. <br>
<i>From this</i> <br>
![From](README/Build_and_Run_1.png)
<br> <i>To this</i> <br>
![To](README/Build_and_Run_2.png)

## 5. Additional
##### <b>Directory:</b> crud-example/Config
Add the `secrets` directory to `.gitignore` if you are using git :)

# How to use
##### <b>Application:</b> Your favorite browser
Fire up `127.0.0.1:8002/`
