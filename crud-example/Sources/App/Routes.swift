import Vapor

final class Routes: RouteCollection {
  
  let view: ViewRenderer
  
  init(_ view: ViewRenderer) {
    self.view = view
  }
  
  func build(_ builder: RouteBuilder) throws {
    
    // GET /
    // return view with navigation
    builder.get { req in
      return try self.view.make("base", ["success": true, "message": "Welcome to my CRUD Example! Feedback is always welcomed :)!"])
    }
    
    // GET read
    // returns view with table of all users
    builder.get("/read") { req in
      
      let userList: [User] = try User.makeQuery().all()
      
      if userList.isEmpty {
        return try self.view.make("read", ["read": "true", "error": true, "message": "There exist no user yet. Go create some!"])
      }
      
      return try self.view.make("read", ["read": "true", "userlist": userList])
    }
    
    // GET create
    // returns view with form to create a user
    builder.get("/create") { req in
      return try self.view.make("create", ["create": "true"])
    }

    // POST create
    // saves data
    builder.post("/create") { req in
      
      guard let username = req.data["username"]?.string else {
        return try self.view.make("create", ["create": "true", "error": true, "message": "Username was missing"])
      }
      
      guard let firstname = req.data["firstname"]?.string else {
        return try self.view.make("create", ["create": "true", "error": true, "message": "Firstname was missing"])
      }
      
      guard let age = req.data["age"]?.int else {
        return try self.view.make("create", ["create": "true", "error": true, "message": "Age was missing or not a number"])
      }
      
      let user = User(username: username, firstname: firstname, age: age)
      try user.save()
      
      return try self.view.make("create",
        [
          "create": "true",
          "success": true,
          "message": "User was successfully created."
        ]
      )
    }
    
    // GET update
    // returns view with table of user ready to update
    builder.get("/update") { req in
      
      let userList = try User.makeQuery().all()
      
      if userList.isEmpty {
        return try self.view.make("update", ["update": "true", "error": true, "message": "There exist no user yet. Go create some!"])
      }
      
      return try self.view.make("update", ["update": "true", "userlist": userList])
    }
    
    // POST update
    builder.post("/update") { req in
      
      var userList = try User.makeQuery().all()
      
      if userList.isEmpty {
        return try self.view.make("update", ["update": "true", "error": true, "message": "There exist no user yet. Go create some!"])
      }
      
      guard let id = req.data["id"]?.int else {
        return try self.view.make("update", ["update": "true", "userlist": userList, "error": true, "message": "id is missing"])
      }
      
      guard let username = req.data["username"]?.string else {
        return try self.view.make("update", ["update": "true", "userlist": userList, "error": true, "message": "username is missing"])
      }
      
      guard let firstname = req.data["firstname"]?.string else {
        return try self.view.make("update", ["update": "true", "userlist": userList, "error": true, "message": "firstname is missing"])
      }
      
      guard let age = req.data["age"]?.int else {
        return try self.view.make("update", ["update": "true", "userlist": userList, "error": true, "message": "age is missing"])
      }
      
      guard let user = try User.makeQuery().filter("id", id).first() else {
        return try self.view.make("update", ["update": "true", "userlist": userList, "error": true, "message": "no user with id \(id) found"])
      }
      
      user.username = username
      user.firstname = firstname
      user.age = age
      try user.save()
      
      userList = try User.makeQuery().all()
      
      return try self.view.make("update", ["update": "true", "userlist": userList, "success": true, "message": "User was susccessfully updated"])
    }
    
    builder.get("delete") { req in
      
      let userList = try User.makeQuery().all()
      
      if userList.isEmpty {
        return try self.view.make("update", ["delete": "true", "error": true, "message": "There exist no user yet. Go create some!"])
      }
      
      return try self.view.make("delete", ["delete": "true", "userlist": userList])
    }
    
    builder.post("delete") { req in
      
      var userList = try User.makeQuery().all()
      
      guard let id = req.data["id"]?.int else {
        return try self.view.make("delete", ["delete": "true", "userlist": userList, "error": true, "message": "id is missing"])
      }
      
      guard let user = try User.makeQuery().filter("id", id).first() else {
        return try self.view.make("delete", ["delete": "true", "userlist": userList, "error": true, "message": "no user with id \(id) found"])
      }
      
      try user.delete()
      userList = try User.makeQuery().all()
      
      return try self.view.make("delete", ["delete": "true", "userlist": userList, "success": true, "message": "User was successfully deleted"])
    }
  }
}
