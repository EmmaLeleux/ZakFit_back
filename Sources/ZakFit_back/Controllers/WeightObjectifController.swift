//
//  WeightObjectifController.swift
//  ZakFit_back
//
//  Created by Emma on 26/11/2025.
//

import Fluent
import Vapor
import JWT


struct WeightObjectifController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("weight-objectif")
        
        
        //routes privées
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.post(use: self.createWeight)
        protectedRoutes.delete(":id", use: deleteWeight)
        protectedRoutes.get(use: getWeightsByUser)
        
        
    }
    
    
    @Sendable
    func createWeight(req: Request) async throws -> WeightObjectifResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let weight = try req.content.decode(CreateWeightObjectifDTO.self).toModel()
        
        weight.$user.id = payload.id
        
        try await weight.save(on: req.db)
        
        return weight.toDTO()
    }
    
    @Sendable
    func getWeightsByUser(req: Request) async throws -> WeightObjectifResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let weight = try await WeightObjectif.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .first()
        else {
            throw Abort(.notFound, reason: "Aucun weight objectif pour cet utilisateur")
        }
        
        return weight.toDTO()
    }
    
    @Sendable
    func deleteWeight(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let weight = try await WeightObjectif.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await weight.delete(on: req.db)
        return .noContent
    }
    
}
