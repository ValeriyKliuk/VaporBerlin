# Tutorial: Build CRUD from scratch.

## Environment
System Requirements | Version |  | Used Packages | Version |
------------ | ------------- | ------------- | ------------- | ------------- |
macOS | Sierra |  | vapor | 2.0.x |
swift | 3.1 |  | postgresql-provider | 2.x |
vapor-toolbox | 2.0.3 |

## 1. Clone the official vapor/api-template
##### <b>Directory:</b> wherever you want to have this project
• Execute in your command line
```bash
$ git clone https://github.com/vapor/api-template.git myProjectName
```

## 2. Add needed dependencies
##### <b>File:</b> myProjectName/Package.swift
• Name your project <br />
• Add postgresql-provider and leaf-provider
```swift
import PackageDescription

let package = Package(
    name: "myProjectName",
    targets: [
        ...
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/fluent-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/postgresql-provider.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1)
    ],
    exclude: [
        ...
    ]
)
```

## 3. Generate Xcode project
##### <b>Directory:<b/> myProjectName/
• Execute in your command line
```bash
$ vapor xcode -y
```

## 4. Set postgresql as driver
##### <b>File:</b> myProjectName/Config/fluent.json
• Change driver from "memory" to "postgresql"
```json
{
  ...
  "driver": "postgresql",
  ...
}
```

## 5. Set postgresql configuration
### 5.1 Create folder with name secrets within Config
##### <b>Directory:</b> myProjectName/Config/
• Execute in your command line
```bash
$ mkdir secrets
```

### 5.2 Create configuration file with name postgresql.json
##### <b>Directory:</b> myProjectName/Config/secrets/
• Execute in your command line
```bash
$ touch postgresql.json
```

### 5.3 Add the following to postgresql.json
##### <b>File:</b> myProjectName/Config/secrets/postgresql.json
• Make sure to replace martinlasek by your database username <br />
• Also think of a name for your database - we'll create it afterwards
```json
{
    "hostname": "127.0.0.1",
    "user": "martinlasek",
    "password": "",
    "database": "myProjectDB",
    "port": 5432
}
```

## 6. Create a database
##### <b>Directory:</b> doesn't matter
• Execute in your command line
```bash
$ createdb myProjectDB
```

## 7. Add postgresql-provider to your project
##### <b>File:</b> myProjectName/Sources/App/Config+Setup.swift
• Import and Add PostgreSQLProvider
```swift
import FluentProvider
import PostgreSQLProvider

extension Config {
    public func setup() throws {
        ...
    }

    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
    }

    private func setupPreparations() throws {
        ...
    }
}
```

## 8. Remove two files
### 8.1 Remove file named Post.swift
#### <b>Directory:</b> myProjectName/Sources/App/Models/
• Execute in your command line
```bash
$ rm Post.swift
```

### 8.2 Remove use of Post (Model) in your project
##### <b>File:</b> myProjectName/Sources/App/Config+Setup.swift
```swift
import FluentProvider
import PostgreSQLProvider

extension Config {
    public func setup() throws {
        ...
    }

    private func setupProviders() throws {
      try addProvider(FluentProvider.Provider.self)
      try addProvider(PostgreSQLProvider.Provider.self)
    }

    private func setupPreparations() throws {
        // delete this line: preparations.append(Post.self)
    }
}

```

### 8.3 Remove file named PostController.swift
#### <b>Directory:</b> myProjectName/Sources/App/Controllers/
• Execute in your command line
```bash
$ rm PostController.swift
```

## 9. (coming soon)
