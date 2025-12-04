//
//  MealDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


struct CreateMealDTO: Content{
    var type: String
    var date: Date
    
    func toModel() -> Meal {
        let model = Meal()
        
        model.type = type
        model.date = date
        return model
        
    }
}

struct UpdateMealDTO: Content{
    var type: String?
}

struct MealResponseDTO: Content {
    var id: UUID
    var type: String
    var date: Date
    var ingredients: [IngredientResponseDTO]
    var totalCalories: Int
    var totalLipides: Int
    var totalProteines: Int
    var totalGlucides: Int
}
