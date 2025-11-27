//
//  MealController.swift
//  ZakFit_back
//
//  Created by Emma on 26/11/2025.
//

import Fluent
import Vapor
import JWT


struct MealController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("meal")
        
        
        //routes privées
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.post(use: self.createMeal)
        protectedRoutes.delete(":id", use: deleteMeal)
        protectedRoutes.get(use: self.getMealsByUser)
   
        
    }
    
    @Sendable
    func createMeal(req: Request) async throws -> MealResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let meal = try req.content.decode(CreateMealDTO.self).toModel()
        
        
        meal.$user.id = payload.id
        
        
        try await meal.save(on: req.db)
        
        return meal.toDTO()
    }
    
    
    @Sendable
    func getMealsByUser(req: Request) async throws -> [MealResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)

        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .all()
        
        return meals.map{$0.toDTO()}
    }
    
   
    @Sendable
    func deleteMeal(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let meal = try await Meal.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await meal.delete(on: req.db)
        return .noContent
    }
}
