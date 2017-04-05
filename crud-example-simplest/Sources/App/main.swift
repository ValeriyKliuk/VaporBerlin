import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(User.self)

drop.get("/") { req in
  
  return "everything is just running fine"
}

drop.get("/user") { req in
  
  return "You can operate on user with: /create, /read, /list, /delete"
}

// CREATE user
drop.get("/user/create") { req in
  
  guard let username = req.data["username"]?.string else {
    return "username is missing. Valid call: /create?username=yourWantedUsername&password=yourSecretPassword"
  }
  
  guard let password = req.data["password"]?.string else {
    return "password is missing. Valid call: /create?username=yourWantedUsername&password=yourSecretPassword"
  }
  
  var newUser = User(username: username, password: password)
  try newUser.save()
  
  return "successfully created new user: \(username)"
}

// READ all users
drop.get("/user/list") { req in
  
  let userList = try User.query().all()
  
  if (userList.count == 0) {
    return "no user exists yet"
  }
  
  return try userList.makeJSON()
}

// UPDATE user
drop.get("/user/update") { req in
  
  guard let username = req.data["username"]?.string else {
    return "username is missing. Valid call: /update?username=yourWantedUsername&password=yourSecretPassword&change=username&value=yourNewUsername"
  }
  
  guard let password = req.data["password"]?.string else {
    return "password is missing. Valid call: /update?username=yourWantedUsername&password=yourSecretPassword&change=username&value=yourNewUsername"
  }
  
  guard let change = req.data["change"]?.string else {
    return "change is missing. Valid call: /update?username=yourWantedUsername&password=yourSecretPassword&change=username&value=yourNewUsername"
  }
  
  guard let newValue = req.data["value"]?.string else {
    return "value is missing. Valid call: /update?username=yourWantedUsername&password=yourSecretPassword&change=username&value=yourNewUsername"
  }
  
  guard var user = try User.query().filter("username", username).first() else {
    return "Couldn't find user: \(username) with password: \(password)"
  }
  
  switch change {
    case "username": user.username = newValue
    case "password": user.password = newValue
    default: return "Wrong change request. Valid change values: username, password."
  }
  
  try user.save()
  
  return "successfully changed \(change) to \(newValue)"
}

// DELETE user
drop.get("/user/delete") { req in
  
  guard let username = req.data["username"]?.string else {
    return "username is missing. Valid call: /delete?username=yourUserName"
  }
  
  guard var user = try User.query().filter("username", username).first() else {
    return "no user found with username: \(username)  "
  }
  
  try user.delete()
  return "successfully deleted \(username)"
}

drop.run()
