# CRUD Example on a User with PostgreSQL
## Setup
### 0. Install PostgreSQL via Homebrew
```bash
# install the binary
$ brew install postgresql

# init it
$ initdb /usr/local/var/postgres

# start the postgres server
$ postgres -D /usr/local/var/postgres
```
### 1. Generate xcode project and open it
##### <b>Directory:</b> crud-example-simplest/
Execute in your command line
```bash
$ vapor xcode -y
```
### 2. Set your database configuration
##### <b>File:</b> crud-example-simplest/Config/secrets/postgresql.json
Change my user `martinlasek` to yours and choose a database name
```JSON
{
  "host": "127.0.0.1",
  "user": "martinlasek",
  "password": "",
  "database": "wisheddatabasename",
  "port": 5432
}
```
### 3. Create the database
##### <b>Directory:</b> <i>doesn't matter</i>
Execute in your command line
```bash
$ createdb wisheddatabasename;
```
### 4. Build and Run
##### <b>Application:</b> Xcode
Make sure before you hit the ► button, that you selected <b> App </b> to the right of the button. <br>
From this <br>
![From](tutorial/images/Build_and_Run_1.png)
<br> To this <br>
![To](tutorial/images/Build_and_Run_2.png)
### 5. Open in Browser
#### <b>Application:</b> Your favorite browser
Call `127.0.0.1:8989/` or `127.0.0.1:8989/user`

### 6. Additional
##### <b>Directory:</b> crud-example-simplest/Config
Add the `secrets` directory to `.gitignore` if you are using git :)
