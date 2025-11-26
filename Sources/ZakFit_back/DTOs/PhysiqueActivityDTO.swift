//
//  PhysiqueActivityDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


struct CreatePhysiqueActivityDTO: Codable {
    var sport: String
    var date: Date
    var cal: Int
    var duration: Date
}


struct PhysiqueActivityResponseDTO: Codable {
    var id: UUID
    var sport: String
    var date: Date
    var cal: Int
    var duration: Date
}
