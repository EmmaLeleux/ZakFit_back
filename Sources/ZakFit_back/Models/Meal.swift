//
//  Meal.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


final class Meal: Model, @unchecked Sendable, Content {
    static let schema = "meal"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "type")
    var type: String
    
    @Field(key: "date")
    var date: Date
    
    @Parent(key: "user_id")
    var user: User
    
    @Siblings(through: IngredientMeal.self, from: \.$meal, to: \.$ingredient)
    var ingredients: [Ingredient]
    
    

    init() {}
    
    
    func toDTO(on db: any Database) async throws -> MealResponseDTO {
        try await $ingredients.load(on: db)
        
        var totalCalories = 0
        var totalLipides = 0
        var totalProteines = 0
        var totalGlucides = 0
        var ingredientsDTO: [IngredientResponseDTO] = []
        for ingredient in ingredients {
            guard let ingredientMeal = try await IngredientMeal.query(on: db)
                .filter(\.$meal.$id == self.requireID())
                .filter(\.$ingredient.$id == ingredient.requireID())
                .first()
            else {
                throw Abort(.notFound)
            }
            
            totalCalories += ingredientMeal.quantity / (ingredient.unit == "100g" ? 100 : 1) * ingredient.cal
            totalLipides += ingredientMeal.quantity / (ingredient.unit == "100g" ? 100 : 1) * ingredient.carbonhydrate
            totalProteines += ingredientMeal.quantity / (ingredient.unit == "100g" ? 100 : 1) * ingredient.protein
            totalGlucides += ingredientMeal.quantity / (ingredient.unit == "100g" ? 100 : 1) * ingredient.glucide
            ingredientsDTO.append(ingredient.toDTO(quantity: ingredientMeal.quantity))
        }
        
        return MealResponseDTO(
            id: id ?? UUID(),
            type: type,
            date: date,
            ingredients: ingredientsDTO,
            totalCalories: totalCalories,
            totalLipides: totalLipides,
            totalProteines: totalProteines,
            totalGlucides: totalGlucides
        )
    }
}
