//
//  Ingredient.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Vapor
import Fluent

final class Ingredient: Model, @unchecked Sendable, Content {
    static let schema = "ingredient"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "cal")
    var cal: Int
    
    @Field(key: "carbonhydrate")
    var carbonhydrate: Int
    
    @Field(key: "protein")
    var protein: Int
    
    @Field(key: "glucide")
    var glucide: Int
    
    @Field(key: "unit")
    var unit: String
    
    @Siblings(through: IngredientMeal.self, from: \.$ingredient, to: \.$meal)
    var meals: [Meal]
    
    init() {}
    
    
    func toDTO(quantity: Int? = nil) -> IngredientResponseDTO{
        return IngredientResponseDTO(
            id: id ?? UUID(),
            name: name,
            cal: cal,
            carbonhydrate: carbonhydrate,
            protein: protein,
            glucide: glucide,
            unit: unit,
        quantity: quantity)
    }
}
