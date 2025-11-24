//
//  MealMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct MealMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("meal")
            .id()
            .field("type", .string, .required)
            .field("date", .date, .required)
            .field("user_id", .uuid, .required, .references("user", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("meal").delete()
    }
}
