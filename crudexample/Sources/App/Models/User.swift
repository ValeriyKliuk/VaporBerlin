import Vapor
import FluentProvider
import HTTP

final class User: Model {

  let storage = Storage()
  var username: String
  var firstname: String
  var age: Int
  
  init(username: String, firstname: String, age: Int) {
    self.username = username
    self.firstname = firstname
    self.age = age
  }

  // MARK: Fluent Serialization

  // Initializes/Creates the User from the
  // database row
  init(row: Row) throws {
    
    username = try row.get("userName")
    firstname = try row.get("firstname")
    age = try row.get("age")
  }

  // Serializes the Post to the database
  func makeRow() throws -> Row {
    
    var row = Row()
    try row.set("username", username)
    try row.set("firstname", firstname)
    try row.set("age", age)
    return row
  }
}

// MARK: Fluent Preparation
extension User: Preparation {
  
  // Prepares a table/collection in the database
  // for storing User
  static func prepare(_ database: Database) throws {
    
    try database.create(self) { builder in
      builder.id()
      builder.string("username")
      builder.string("firstname")
      builder.int("age")
    }
  }

  // Undoes what was done in `prepare`
  static func revert(_ database: Database) throws {
      
    try database.delete(self)
  }
}

// MARK: JSON

// How the model converts from / to JSON.
extension User: JSONConvertible {
  
  convenience init(json: JSON) throws {
    
    try self.init(
      username: json.get("username"),
      firstname: json.get("firstname"),
      age: json.get("age")
    )
  }
  
  // function to create json object
  // and set key and value
  func makeJSON() throws -> JSON {
    
    var json = JSON()
    
    try json.set("id", id)
    try json.set("username", username)
    try json.set("firstname", firstname)
    try json.set("age", age)
    
    return json
  }
}

// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension User: ResponseRepresentable { }
