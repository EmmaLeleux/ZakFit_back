//
//  Untitled.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


struct CreateIngredientDTO: Content{
    var name: String
    var cal: Int
    var carbonhydrate: Int
    var protein: Int
    var glucide: Int
    var unit: String
    
    func toModel() -> Ingredient {
        let model = Ingredient()
        model.id = UUID()
        model.name = name
        model.cal = cal
        model.carbonhydrate = carbonhydrate
        model.protein = protein
        model.glucide = glucide
        model.unit = unit
        return model
    }
}


struct IngredientResponseDTO: Content {
    var id: UUID
    var name: String
    var cal: Int
    var carbonhydrate: Int
    var protein: Int
    var glucide: Int
    var unit: String
}
