//
//  WeightObjectif.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//


import Fluent
import Vapor

struct CreateWeightObjectif: Content{
    var weightObjectif: Double
    var timing: String
    var startDate: Date
    var finalDate: Date
}

struct WeightObjectifResponse: Content{
    var id: UUID?
    var weightObjectif: Double
    var timing: String
    var startDate: Date
    var finalDate: Date
}
