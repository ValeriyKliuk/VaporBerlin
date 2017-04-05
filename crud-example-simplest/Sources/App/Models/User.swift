import Vapor
import Fluent

final class User: Model {
  
  var id: Node?
  var username: String
  var password: String
  
  init(username: String, password: String) {
    self.id = nil
    self.username = username
    self.password = password
  }
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    username = try node.extract("username")
    password = try node.extract("password")
  }
}

extension User {
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "username": username,
      "password": password
      ])
  }
}

extension User {
  
  static func prepare(_ database: Database) throws {
    try database.create("users") { user in
      user.id()
      user.string("username")
      user.string("password")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("users")
  }
}
