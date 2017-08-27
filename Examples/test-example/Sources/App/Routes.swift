import Vapor

extension Droplet {
  
    func setupRoutes() throws {
      
      /// CREATE user
      /// http method: post
      post("user") { req in
        
        // check request constains json
        guard let json = req.json else {
          
          throw Abort(.badRequest, reason: "no json provided")
        }
        
        let user: User
        
        // try to initialize user with json
        do {
          
          user = try User(json: json)
        }
        catch {
          
          throw Abort(.badRequest, reason: "incorrect json")
        }
        
        // save user
        try user.save()
        
        // return user
        return try user.makeJSON()
      }
      
      /// READ user by given id
      /// http method: get
      get("user", Int.parameter) { req in
        
        // get id from url
        let userId = try req.parameters.next(Int.self)
        
        // find user with given id
        guard let user = try User.find(userId) else {
          
          throw Abort(.badRequest, reason: "user with id \(userId) does not exist")
        }
        
        // return user as json
        return try user.makeJSON()
      }
      
      /// UPDATE user fully
      /// http method: put
      put("user", Int.parameter) { req in
        
        // get userId from url
        let userId = try req.parameters.next(Int.self)
        
        // find user by given id
        guard let user = try User.find(userId) else {
          
          throw Abort(.badRequest, reason: "user with given id: \(userId) could not be found")
        }
        
        // check username is provided by json
        guard let username = req.data["username"]?.string else {
         
          throw Abort(.badRequest, reason: "no username provided")
        }
        
        // check age is provided by json
        guard let age = req.data["age"]?.int else {
          
          throw Abort(.badRequest, reason: "no age provided")
        }
        
        // set new values to found user
        user.username = username
        user.age = age
        
        // save user with new values
        try user.save()
        
        // return user as json
        return try user.makeJSON()
      }
      
      /// DELETE user by id
      /// http method: delete
      delete("user", Int.parameter) { req in
        
        // get user id from url
        let userId = try req.parameters.next(Int.self)
        
        // find user with given id
        guard let user = try User.find(userId) else {
          
          throw Abort(.badRequest, reason: "user with id \(userId) does not exist")
        }
        
        // delete user
        try user.delete()
        
        return try JSON(node: ["type": "success", "message": "user with id \(userId) were successfully deleted"])
      }
      
      /// return array or user objects
      ///
      get("user/list") { req in
        
        let userlist = try User.makeQuery().all()
        return try userlist.makeJSON()
      }
    }
}
