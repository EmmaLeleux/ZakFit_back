import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Formatter for dates like "yyyy/MM/dd"
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(formatter)
    
    ContentConfiguration.global.use(decoder: decoder, for: .json)
    ContentConfiguration.global.use(encoder: encoder, for: .json)
    
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "127.0.0.1",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 3306,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "ZakFitDB"
    ), as: .mysql)

    app.migrations.add(UserMigration())
    app.migrations.add(WeightMigration())
    app.migrations.add(WeightObjectifMigration())
    app.migrations.add(PhysiqueActivityMigration())
    app.migrations.add(MealMigration())
    app.migrations.add(IngredientMigration())
    app.migrations.add(IngredientMealMigration())
    app.migrations.add(DietMigration())
    try await app.autoMigrate()
    // register routes
    try routes(app)
}
