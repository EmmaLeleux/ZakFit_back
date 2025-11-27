//
//  WeightObjectif.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor



final class WeightObjectif: Model, @unchecked Sendable, Content {
    static let schema = "weightObjectif"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "weightObjectif")
    var weight: Double
    
    @Field(key: "timing")
    var timing: String
    
    @Field(key: "startDate")
    var startDate: Date
    
    @Field(key: "finalDate")
    var finalDate: Date
    
    @Parent(key: "user_id")
    var user: User
    

    init() {}
    
    
    func toDTO() -> WeightObjectifResponseDTO{
        return WeightObjectifResponseDTO(
            id: id ?? UUID(),
            weightObjectif: weight,
            timing: timing,
            startDate: startDate,
            finalDate: finalDate)
    }
}
