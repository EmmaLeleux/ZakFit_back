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
    
  
    
    

    init() {}
    
    
//    func toDTO() -> UserResponseDTO{
//        return UserResponseDTO(
//
//        )
//    }
}
