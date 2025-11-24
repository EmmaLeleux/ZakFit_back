//
//  PhysiqueActivity.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


final class PhysiqueActivity: Model, @unchecked Sendable, Content {
    static let schema = "physiqueActivity"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "sport")
    var sport: String
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "cal")
    var cal: Int
    
    @Field(key: "duration")
    var duration: Date
    
    @Parent(key: "user_id")
    var user: User
    
  
    
    

    init() {}
    
    
//    func toDTO() -> UserResponseDTO{
//        return UserResponseDTO(
//
//        )
//    }
}
