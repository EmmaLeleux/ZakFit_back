//
//  PhysiqueActivityDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


struct CreatePhysiqueActivityDTO: Content{
    var sport: String
    var date: Date
    var cal: Int
    var duration: Int
    
    func toModel() -> PhysiqueActivity {
        let model = PhysiqueActivity()
        model.sport = sport
        model.date = date
        model.cal = cal
        model.duration = duration
        return model
    }
}


struct PhysiqueActivityResponseDTO: Content {
    var id: UUID
    var sport: String
    var date: Date
    var cal: Int
    var duration: Int
}
