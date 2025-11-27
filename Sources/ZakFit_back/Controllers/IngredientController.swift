//
//  IngredientController.swift
//  ZakFit_back
//
//  Created by Emma on 26/11/2025.
//

import Fluent
import Vapor
import JWT


struct IngredientController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("ingredient")
        
        
        //routes privées
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.post(use: self.createIngredient)
        protectedRoutes.delete(":id", use: deleteIngredient)
        protectedRoutes.get(use: self.getIngredients)
   
        
    }
    
    @Sendable
    func createIngredient(req: Request) async throws -> IngredientResponseDTO {
        try req.auth.require(UserPayload.self)
        
        let ingredient = try req.content.decode(CreateIngredientDTO.self).toModel()
        
        try await ingredient.save(on: req.db)
        
        return ingredient.toDTO()
    }
    
    
    @Sendable
    func getIngredients(req: Request) async throws -> [IngredientResponseDTO] {
        try req.auth.require(UserPayload.self)

        let ingredients = try await Ingredient.query(on: req.db)
            .all()
        
        return ingredients.map{$0.toDTO()}
    }
    
   
    @Sendable
    func deleteIngredient(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let ingredient = try await Ingredient.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await ingredient.delete(on: req.db)
        return .noContent
    }
}
