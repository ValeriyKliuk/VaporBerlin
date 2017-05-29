import PackageDescription

let package = Package(
  name: "crud-example",
  targets: [
    Target(name: "App"),
    Target(name: "Run", dependencies: ["App"]),
  ],
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", versions: Version(2,0,2)..<Version(2,0,3)),
    .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 1),
    .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1),
    .Package(url: "https://github.com/vapor/postgresql-provider.git", majorVersion: 2)
  ],
  exclude: [
    "Config",
    "Database",
    "Localization",
    "Public",
    "Resources",
  ]
)

