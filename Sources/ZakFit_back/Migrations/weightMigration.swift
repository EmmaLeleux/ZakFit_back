//
//  weightMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct WeightMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("weight")
            .id()
            .field("weight", .double, .required)
            .field("date", .date, .required)
            .field("user_id", .uuid, .required, .references("user", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("weight").delete()
    }
}
