//
//  PhysiqueActivityMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct PhysiqueActivityMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("physiqueActivity")
            .id()
            .field("sport", .string, .required)
            .field("date", .date, .required)
            .field("cal", .int, .required)
            .field("duration", .datetime, .required)
            .field("user_id", .uuid, .required, .references("user", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("physiqueActivity").delete()
    }
}
