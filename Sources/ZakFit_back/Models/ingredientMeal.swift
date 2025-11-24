//
//  ingredientMeal.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor



final class IngredientMeal: Model, @unchecked Sendable, Content {
    static let schema = "ingredientMeal"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "quantity")
    var quantity: Int
    
    @Parent(key: "meal_id")
    var meal: Meal
    
    @Parent(key: "ingredient_id")
    var ingredient: Ingredient
    

    init() {}
    
    
//    func toDTO() -> UserResponseDTO{
//        return UserResponseDTO(
//
//        )
//    }
}
