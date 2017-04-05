# CRUD Example
#### REQUIREMENT: You have PostgreSQL installed on your mac. If not here is how to: [Link is coming soon...]()
## Setup
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
$ psql
$ CREATE DATABASE wisheddatabasename;
$ \q
```
### 4. Build and Run
##### <b>Application:</b> Xcode
Make sure before you hit the ► button, that you selected <b> App </b> to the right of the button. <br>
From this <br>
![From](tutorial/images/Build_and_Run_1.png)
<br> To this <br>
![To](tutorial/images/Build_and_Run_2.png)
