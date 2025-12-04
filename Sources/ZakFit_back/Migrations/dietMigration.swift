//
//  dietMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct DietMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("diet")
            .id()
            .field("name", .string, .required)
            .field("user_id", .uuid, .required, .references("user", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("diet").delete()
    }
}
