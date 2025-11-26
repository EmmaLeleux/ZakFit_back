//
//  DietController.swift
//  ZakFit_back
//
//  Created by Emma on 25/11/2025.
//

import Fluent
import Vapor
import JWT


struct DietController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("diet")
        
        
        //routes privées
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.post(use: self.createDiet)
        protectedRoutes.delete(":id", use: deleteDiet)
   
        
    }
    
    @Sendable
    func createDiet(req: Request) async throws -> DietResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let diet = try req.content.decode(CreateDietDTO.self).toModel()
        
        diet.$user.id = payload.id
        
        try await diet.save(on: req.db)
        
        return diet.toDTO()
    }
    
    /// delete a diet
    ///
    /// - Parameters:
    ///     - req : http request with Json informations
    ///     - id : diet's if
    /// - Throws : 404 error if diet not fount
    /// - Return : HTTPStatus
    @Sendable
    func deleteDiet(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let diet = try await Diet.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await diet.delete(on: req.db)
        return .noContent
    }
}
