//
//  UserPt2Migration.swift
//  ZakFit_back
//
//  Created by Emma on 29/11/2025.
//




import Fluent

struct UserPt2Migration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("user")
            .field("genre", .string, .required)
            .field("objLipides", .int, .required)
            .field("objGlucides", .int, .required)
            .field("objProtein", .int, .required)
            .field("frequenceEntrainement", .int, .required)
            .field("minProgression", .int, .required)
            .field("timingProgression", .string, .required)
            .field("isOnBoardCompleted", .bool, .required)
            .update()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("user").delete()
    }
}
