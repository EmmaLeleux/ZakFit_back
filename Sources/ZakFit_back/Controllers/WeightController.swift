//
//  WeightDTO.swift
//  ZakFit_back
//
//  Created by Emma on 25/11/2025.
//

import Fluent
import Vapor
import JWT


struct WeightController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("diet")
        
        
        //routes privées
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.post(use: self.createWeight)
        protectedRoutes.delete(":id", use: deleteDiet)
        
        
    }
    
    
    @Sendable
    func createWeight(req: Request) async throws ->WeightResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let diet = try req.content.decode(CreateWeightDTO.self).toModel()
        
        diet.$user.id = payload.id
        
        try await diet.save(on: req.db)
        
        return diet.toDTO()
    }
    
    
}
