//
//  DietDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor

struct CreateDietDTO: Content{
    var name: String
    
    func toModel() -> Diet {
        let model = Diet()
        model.name = name
        return model
    }
}


struct DietResponseDTO: Content{
    var id: UUID
    var name: String
}
