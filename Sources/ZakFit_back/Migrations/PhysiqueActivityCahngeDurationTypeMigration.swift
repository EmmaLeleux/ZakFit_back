//
//  PhysiqueActivityCahngeDurationTypeMigration.swift
//  ZakFit_back
//
//  Created by Emma on 27/11/2025.
//

import Fluent

struct PhysiqueActivityDurationIntMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {

        try await database.schema("physiqueActivity")
            .deleteField("duration")
            .update()
        
        
        try await database.schema("physiqueActivity")
            .field("duration", .int, .required)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("physiqueActivity")
            .deleteField("duration")
            .update()
        
        try await database.schema("physiqueActivity")
            .field("duration", .datetime, .required)
            .update()
    }
}
