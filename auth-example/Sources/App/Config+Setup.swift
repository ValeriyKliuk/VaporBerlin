import FluentProvider
import PostgreSQLProvider
import AuthProvider

extension Config {
  public func setup() throws {
    // allow fuzzy conversions for these types
    // (add your own types here)
    Node.fuzzy = [Row.self, JSON.self, Node.self]

    try setupProviders()
    try setupPreparations()
  }
  
  private func setupProviders() throws {
    try addProvider(FluentProvider.Provider.self)
    try addProvider(PostgreSQLProvider.Provider.self)
    try addProvider(AuthProvider.Provider.self)
  }
  
  private func setupPreparations() throws {
    preparations.append(User.self)
    preparations.append(Token.self)
  }
}
