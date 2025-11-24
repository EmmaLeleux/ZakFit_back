//
//  Diet.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor

final class Diet: Model, @unchecked Sendable, Content {
    static let schema = "diet"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Parent(key: "user_id")
    var user: User
    
  
    
    

    init() {}
    
    
    func toDTO() -> DietResponseDTO{
        return DietResponseDTO(
            id: id ?? UUID(),
            name: name)
    }
}
