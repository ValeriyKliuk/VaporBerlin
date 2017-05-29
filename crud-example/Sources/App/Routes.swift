import Vapor

final class Routes: RouteCollection {
  
  let view: ViewRenderer
  
  init(_ view: ViewRenderer) {
    self.view = view
  }
  
  func build(_ builder: RouteBuilder) throws {
    
    // returns view with table of all users
    builder.get("/read") { req in
      
      let userList = try User.makeQuery().all()
      
      if userList.isEmpty {
        
        return try self.view.make("read", ["read": "true", "error": "There exist no user yet. Go create some!"])
      }
      
      // render read.leaf and pass read as true and userlist
      return try self.view.make("read", ["read": "true", "userlist": userList])
    }
    
    // returns form to create a user
    builder.get("/create") { req in
      
      return try self.view.make("create", ["create": "true"])
    }

    // POST is the right method to create data
    builder.post("/create") { req in
      
      guard let username = req.data["username"]?.string else {
        
        return try self.view.make("create", ["create": "true", "error": true, "message": "username was missing"])
      }
      
      guard let firstname = req.data["firstname"]?.string else {
        
        return try self.view.make("create", ["create": "true", "error": true, "message": "firstname was missing"])
      }
      
      guard let age = req.data["age"]?.int else {
        
        return try self.view.make("create", ["create": "true", "error": true, "message": "age was missing or not a number"])
      }
      
      let user = User(username: username, firstname: firstname, age: age)
      try user.save()
      
      return try self.view.make("create",
        [
          "create": "true",
          "success": true,
          "message": "user was successfully created."
        ]
      )
    }
  }
}
