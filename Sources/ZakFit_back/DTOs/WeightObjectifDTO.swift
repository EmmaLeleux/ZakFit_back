//
//  WeightObjectif.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//


import Fluent
import Vapor

struct CreateWeightObjectifDTO: Content{
    var weightObjectif: Double
    var timing: String
    var startDate: Date
    var finalDate: Date
    
    func toModel() -> WeightObjectif {
        let model = WeightObjectif()
        model.weight = weightObjectif
        model.timing = timing
        model.startDate = startDate
        model.finalDate = finalDate
        
        return model
    }
}

struct WeightObjectifResponseDTO: Content{
    var id: UUID?
    var weightObjectif: Double
    var timing: String
    var startDate: Date
    var finalDate: Date
}
