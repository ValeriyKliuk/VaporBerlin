import Vapor
import VaporPostgreSQL
import Auth
import Turnstile

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(User.self)
drop.middleware.append(AuthMiddleware(user: User.self))

drop.get("/") { req in
  
  return "Everything is just running fine"
}

drop.get("user") { req in
  
  return "You can operate with: /list, /register, /login, /logout, /profile"
}

// LIST user
drop.get("user/list") { req in
  
  return try User.query().all().makeJSON()
}

// REGISTER user
drop.get("user/register") { req in
  
  guard let username = req.data["username"]?.string else {
    return "username is missing. Valid call: /register?username=yourWantedUsername&password=yourSecretPassword"
  }
  
  guard let password = req.data["password"]?.string else {
    return "password is missing. Valid call: /register?username=yourWantedUsername&password=yourSecretPassword"
  }
  
  let credentials = UsernamePassword(username: username, password: password)
  
  var user = try User.register(credentials: credentials)
  
  return "successfully registered"
}

// LOGIN user
drop.get("user/login") { req in
  
  guard let username = req.data["username"]?.string else {
    return "username is missing. Valid call: /login?username=yourWantedUsername&password=yourSecretPassword"
  }
  
  guard let password = req.data["password"]?.string else {
    return "password is missing. Valid call: /login?username=yourWantedUsername&password=yourSecretPassword"
  }
  
  let credentials = UsernamePassword(username: username, password: password)
  
  do {
    try req.auth.login(credentials)
    return "you are logged in now"
    
  } catch {
    return "couldn't log you in"
  }
}

// LOGOUT user
drop.get("user/logout") { req in
  
  try req.auth.logout()
  return "successfully logged out"
}

// SHOW PROFILE of user
drop.get("user/profile") { req in
  
  // getting user from session, if not existing: abort
  guard let user = try req.auth.user() as? User else {
      return "not allowed to see this"
  }
  
  return "you are looking at your profile"
}

drop.run()
