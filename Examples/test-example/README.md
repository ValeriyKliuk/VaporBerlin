## Tutorial
[How to write tests with Vapor 2](https://medium.com/@martinlasek/tutorial-how-to-write-tests-with-vapor-2-73f600d4ea8b)

## Setup
[How to setup](README/setup.md)

## Use

### Run
##### <b>Application:</b> Xcode
Make sure before you hit the ► button, that you select the <b> Run </b> Scheme to the right of the button. <br>
<i>From this</i> <br>
![From](README/images/Build_and_run_1.png)
<br> <i>To this</i> <br>
![To](README/images/Build_and_run_2.png)

### Endpoints
#### Create user <br/>
method: `POST` <br/>
route: `127.0.0.1:8003/user` <br/>
json:
```json
username: "Luke Skywalker"
age: 23
```

#### Read user
method: `GET` <br/>
route: `127.0.0.1:8003/user/userId` <br/>
variable: `userId` of type `int`

#### Update user
method: `PUT` <br/>
route: `127.0.0.1:8003/user/userId` <br/>
variable: `userId` of type `int` <br/>
json:
```json
username: "Yoda"
age: 791
```

#### Delete user
method: `DELETE` <br/>
route: `127.0.0.1:8003/user/userId` <br/>
variable. `userId` of type `int`
