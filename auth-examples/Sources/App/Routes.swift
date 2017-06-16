import Vapor
import AuthProvider

extension Droplet {
  func setupRoutes() throws {
    get("/") { req in
      return "we are all up and running"
    }
    
    // POST create user
    post("register") { req in
      
      guard let json = req.json else {
        throw Abort(.badRequest, reason: "no json provided")
      }
      
      let user = try User(
        firstname: json.get("firstname"),
        username: json.get("username")
      )
      
      guard try User.makeQuery().filter("username", user.username).first() == nil else {
        throw Abort(.badRequest, reason: "username already exists")
      }
      
      guard let password = json["password"]?.string else {
        throw Abort(.badRequest, reason: "no password given")
      }
      
      user.password = try BCryptHasher().make(password.bytes).makeString()
      
      try user.save()
      return user
    }
    
    let passwordMiddleware = PasswordAuthenticationMiddleware(User.self)
    let authed = self.grouped(passwordMiddleware)
    
    authed.get("login") { req in
      let user = try req.auth.assertAuthenticated(User.self)
      let token = try Token.generate(for: user)
      try token.save()
      return try token.makeJSON()
    }
    
    let tokenMiddlerware = TokenAuthenticationMiddleware(User.self)
    let token = self.grouped(tokenMiddlerware)
    
    token.get("profile") { req in
      let user = try req.auth.assertAuthenticated(User.self)
      return "you are viewing your profile"
    }
  }
}
