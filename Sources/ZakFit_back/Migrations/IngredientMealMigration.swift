//
//  IngredientMealMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct IngredientMealMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("ingredientMeal")
            .id()
            .field("quantity", .int, .required)
            .field("meal_id", .uuid, .required, .references("meal", "id"))
            .field("ingredient_id", .uuid, .required, .references("ingredient", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("ingredientMeal").delete()
    }
}
