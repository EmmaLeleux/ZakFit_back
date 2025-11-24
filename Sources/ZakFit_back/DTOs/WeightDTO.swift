//
//  WeightDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//


import Fluent
import Vapor

struct CreateWeightDTO: Content{
    var weight: Double
    var date: Date
    
}

struct WeightResponseDTO: Content{
    var id: UUID?
    var weight: Double
    var date: Date
}
