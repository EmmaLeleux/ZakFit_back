//
//  IngredientMealController.swift
//  ZakFit_back
//
//  Created by Emma on 26/11/2025.
//

import Fluent
import Vapor
import JWT


struct IngredientMealController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("ingredient-meal")
        
        
        //routes privées
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.post(use: self.createIngredientMeal)
        protectedRoutes.delete(":id", use: deleteIngredientMeal)
        protectedRoutes.get(use: self.getIngredientMeals)
   
        
    }
    
    @Sendable
    func createIngredientMeal(req: Request) async throws -> IngredientMealResponseDTO {
        try req.auth.require(UserPayload.self)
        
        let ingredient = try req.content.decode(CreateIngredientMealDTO.self).toModel()
        
        try await ingredient.save(on: req.db)
        
        return ingredient.toDTO()
    }
    
    
    @Sendable
    func getIngredientMeals(req: Request) async throws -> [IngredientMealResponseDTO] {
        try req.auth.require(UserPayload.self)

        let ingredients = try await IngredientMeal.query(on: req.db)
            .all()
        
        return ingredients.map{$0.toDTO()}
    }
    
   
    @Sendable
    func deleteIngredientMeal(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let ingredient = try await IngredientMeal.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await ingredient.delete(on: req.db)
        return .noContent
    }
}
