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
    


    init() {}
    
    
//    func toDTO() -> UserResponseDTO{
//        return UserResponseDTO(
//
//        )
//    }
}
