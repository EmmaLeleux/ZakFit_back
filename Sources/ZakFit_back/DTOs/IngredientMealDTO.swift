//
//  IngredientMealDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


struct CreateIngredientMealDTO: Content{
    var quantity: Int
    var mealId: UUID
    var ingredientId: UUID
    
    func toModel() -> IngredientMeal {
        let model = IngredientMeal()
        model.id = UUID()
        model.meal.id = mealId
        model.ingredient.id = ingredientId
        model.quantity = quantity
        
        return model
    }
    
}

struct UpdateIngredientMealDTO: Content{
    var quandtity: Int?
    var mealId: UUID?
    var ingredientId: UUID?
}

struct IngredientMealResponseDTO: Content {
    var id: UUID
    var quantity: Int
    var mealId: UUID
    var ingredientId: UUID
    
}
