//
//  Weight.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor



final class Weight: Model, @unchecked Sendable, Content {
    static let schema = "weight"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "weight")
    var weight: Double
    
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
