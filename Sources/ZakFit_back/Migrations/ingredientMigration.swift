//
//  ingredientMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct IngredientMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("ingredient")
            .id()
            .field("name", .string, .required)
            .field("cal", .int, .required)
            .field("carbonhydrate", .int, .required)
            .field("protein", .int, .required)
            .field( "glucide", .int, .required)
            .field("unit", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("ingredient").delete()
    }
}
