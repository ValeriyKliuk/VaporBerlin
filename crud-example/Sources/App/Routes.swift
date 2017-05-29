import Vapor

final class Routes: RouteCollection {
  
  let view: ViewRenderer
  
  init(_ view: ViewRenderer) {
    self.view = view
  }
  
  func build(_ builder: RouteBuilder) throws {
    
    builder.get("/") { req in
      
      return try self.view.make("base", ["read": "true"])
    }

    builder.get("plaintext") { req in
      return "Hello, world!"
    }
        
    // response to requests to /info domain
    // with a description of the request
    builder.get("info") { req in
      return req.description
    }
  }
}
