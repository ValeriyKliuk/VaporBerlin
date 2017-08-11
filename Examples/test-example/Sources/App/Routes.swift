import Vapor
import Random

extension Droplet {
  
    func setupRoutes() throws {
      
      /// CREATE user
      ///
      post("user/create") { req in
        
        // check username is provided
        guard let username = req.data["username"]?.string else {
          
          throw Abort(.badRequest, reason: "no username provided")
        }
        
        // check age is provided
        guard let age = req.data["age"]?.int else {
          
          throw Abort(.badRequest, reason: "no age provided")
        }
        
        // save user with provided data
        let user = User(username: username, age: age)
        try user.save()
        
        // return
        return try user.makeJSON()
      }
      
      /// READ user by given id
      ///
      get("user", Int.parameter) { req in
        
        // get id from url
        let userId = try req.parameters.next(Int.self)
        
        // find user with given id
        guard let user = try User.find(userId) else {
          
          return try JSON(node: ["type":"error", "message": "user with id \(userId) could not be found."])
        }
        
        // return user as json
        return try user.makeJSON()
      }
      
      /// UPDATE user fully
      ///
      put("user/update", Int.parameter) { req in
        
        let userId = try req.parameters.next(Int.self)
        
        guard let user = try User.find(userId) else {
          
          throw Abort(.badRequest, reason: "user with given id: \(userId) could not be found")
        }
        
        guard let username = req.data["username"]?.string else {
         
          throw Abort(.badRequest, reason: "no username provided")
        }
        
        guard let age = req.data["age"]?.int else {
          
          throw Abort(.badRequest, reason: "no age provided")
        }
        
        user.username = username
        user.age = age
        try user.save()
        
        return try user.makeJSON()
      }
      
      /// DELETE user by id
      ///
      delete("user/delete", Int.parameter) { req in
        
        // get user id from url
        let userId = try req.parameters.next(Int.self)
        
        // find user with given id
        guard let user = try User.find(userId) else {
          
          return try JSON(node: ["type": "error", "message": "user with id \(userId) does not exist"])
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
