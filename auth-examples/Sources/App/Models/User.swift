import FluentProvider
import AuthProvider

final class User: Model {
  let storage = Storage()
  var firstname: String
  var username: String
  var password: String?
  
  init(firstname: String, username: String, password: String? = nil) {
    self.firstname = firstname
    self.username = username
    self.password = password
  }
  
  init(row: Row) throws {
    firstname = try row.get("firstname")
    username = try row.get("username")
    password = try row.get("password")
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("firstname", firstname)
    try row.set("username", username)
    try row.set("password", password)
    return row
  }
}

extension User: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      
      builder.id()
      builder.string("firstname")
      builder.string("username")
      builder.string("password")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension User: ResponseRepresentable { }

extension User: JSONRepresentable {
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("firstname", firstname)
    try json.set("username", username)
    return json
  }
}

// MARK: Auth

extension User: TokenAuthenticatable {
  public typealias TokenType = Token
}

extension User: PasswordAuthenticatable {
  
  static var usernameKey = "username"
  
  var hashedPassword: String? {
    return password
  }
  
  static var passwordVerifier: PasswordVerifier? {
    return MyPasswordVerifier()
  }
}

struct MyPasswordVerifier: PasswordVerifier {
  
  func verify(password: Bytes, matches hash: Bytes) throws -> Bool {
    return try BCryptHasher().verify(password: password, matches: hash)
  }
}
