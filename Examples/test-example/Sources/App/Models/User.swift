import Vapor
import FluentProvider
import HTTP

final class User: Model {
  
  let storage = Storage()
  
  var username: String
  var age: Int
  
  init(username: String, age: Int) {
    
    self.username = username
    self.age = age
  }
  
  /// MARK: Fluent Serialization
  
  init(row: Row) throws {
    
    username = try row.get("username")
    age = try row.get("age")
  }
  
  func makeRow() throws -> Row {
    
    var row = Row()
    try row.set("username", username)
    try row.set("age", age)
    return row
  }
}

/// MARK: Fluent Preparation
extension User: Preparation {
  
  // prepares a table in the database
  static func prepare(_ database: Database) throws {
    
    try database.create(self) { builder in
      builder.id()
      builder.string("username")
      builder.int("age")
    }
  }
  
  // deletes the table from the database
  static func revert(_ database: Database) throws {
    
    try database.delete(self)
  }
}

/// MARK: JSON
extension User: JSONConvertible {
  
  convenience init(json: JSON) throws {
    
    self.init(
      username: try json.get("username"),
      age: try json.get("age")
    )
  }
  
  func makeJSON() throws -> JSON {
    
    var json = JSON()
    try json.set(User.idKey, id)
    try json.set("username", username)
    try json.set("age", age)
    return json
  }
}

/// MARK: Needed so we can pass it to the view
extension User: NodeConvertible {
  
  func makeNode(in context: Context?) throws -> Node {
    
    return try Node(node: [
      "id": id ?? 0,
      "username": username,
      "age": age
    ])
  }
}
