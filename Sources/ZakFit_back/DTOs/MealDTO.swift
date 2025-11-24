//
//  MealDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


struct CreateMealDTO: Content{
    var type: String
    var date: Date
    
}

struct MealResponseDTO: Content {
    var id: UUID
    var type: String
    var date: Date
}
