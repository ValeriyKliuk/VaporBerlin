import Vapor
import Fluent
import Auth
import Turnstile
import BCrypt

final class User: Model {
  
  var id: Node?
  var username: String
  var password: String
  
  init(username: String, password: String) {
    self.username = username
    self.password = password
  }
  
  init(node: Node, in context: Context) throws {
    self.id = try node.extract("id")
    self.username = try node.extract("username")
    self.password = try node.extract("password")
  }
}

extension User {
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
        "id": self.id,
        "username": self.username,
        "password": self.password
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

extension User: Auth.User {
  
  /*
  ** Authentication
  */
  static func authenticate(credentials: Credentials) throws -> Auth.User {
    
    switch credentials {
      
      // UsernamePassword
      case let usernamePassword as UsernamePassword:
        let fetchedUser = try User.query().filter("username", usernamePassword.username).first()
      
        guard let user = fetchedUser else {
          throw Abort.custom(status: .networkAuthenticationRequired, message: "User with username: \(usernamePassword.username) doesn't exist")
        }
      
        if try BCrypt.verify(password: usernamePassword.password, matchesHash: user.password) {
          return user
        } else {
            throw Abort.custom(status: .networkAuthenticationRequired, message: "Wrong password")
        }
      
      // Identifier (needed for `req.auth.user()` to get the current logged in user
      case let identifier as Identifier:
        guard let user = try User.find(identifier.id) else {
            throw Abort.custom(status: .forbidden, message: "Invalid User Identifier")
        }
      
        return user
      
      // Default
      default:
        let type = type(of: credentials)
        throw Abort.custom(status: .forbidden, message: "Unsupported credentials type: \(type)")
    }
  }
  
  /*
  ** Registration
  */
  static func register(credentials: Credentials) throws -> Auth.User {
    
    guard let usernamePassword = credentials as? UsernamePassword else {
      let type = type(of: credentials)
      throw Abort.custom(status: .forbidden, message: "Unsupported credentials type: \(type)")
    }
    
    var user = User(username: usernamePassword.username, password: try BCrypt.digest(password: usernamePassword.password))
    
    // get's the user from database with same username, if existing: abort
    if let fetchedUser = try User.query().filter("username", user.username).first() {
      throw Abort.custom(status: .badRequest, message: "username already exists")
    }
    
    try user.save()
    
    return user
  }
}
