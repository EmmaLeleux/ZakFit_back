//
//  weightObjectifMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct WeightObjectifMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("weightObjectif")
            .id()
            .field("weightObjectif", .double, .required)
            .field("timing", .string, .required)
            .field("startDate", .date, .required)
            .field("finalDate", .date, .required)
            .field("user_id", .uuid, .required, .references("user", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("weightObjectif").delete()
    }
}
