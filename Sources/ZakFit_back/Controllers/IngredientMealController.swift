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
        protectedRoutes.delete(":mealId", "ingredient", ":ingredientId", use: deleteIngredientMeal)
        protectedRoutes.get(use: self.getIngredientMeals)
        protectedRoutes.patch(":mealId", "ingredient", ":ingredientId", use: updateIngredientMeal)
   
        
    }
    
    @Sendable
    func createIngredientMeal(req: Request) async throws -> IngredientMealResponseDTO {
        try req.auth.require(UserPayload.self)
        
        let ingredient = try req.content.decode(CreateIngredientMealDTO.self).toModel()
        
        try await ingredient.save(on: req.db)

        try await ingredient.$ingredient.load(on: req.db)
        
        let meal = try await ingredient.$meal.get(on: req.db)
        try await meal.$ingredients.load(on: req.db)

        return ingredient.toDTO()
    }
    
    
    @Sendable
    func getIngredientMeals(req: Request) async throws -> [IngredientMealResponseDTO] {
        try req.auth.require(UserPayload.self)

        let ingredients = try await IngredientMeal.query(on: req.db)
            .with(\.$meal)
            .with(\.$ingredient)
            .all()
        
        return ingredients.map{$0.toDTO()}
    }
    
    @Sendable
    func updateIngredientMeal(req: Request) async throws -> Response {
        try req.auth.require(UserPayload.self)
        
        guard let mealIdString = req.parameters.get("mealId"),
              let mealId = UUID(uuidString: mealIdString) else {
            throw Abort(.badRequest, reason: "id de repas invalide")
        }
        
       
        guard let ingredientIdString = req.parameters.get("ingredientId"),
              let ingredientId = UUID(uuidString: ingredientIdString) else {
            throw Abort(.badRequest, reason: "id d'ingredient invalide")
        }
        
        guard let ingredient = try await Ingredient.find(ingredientId, on: req.db) else {
            throw Abort(.notFound, reason: "ingredient introuvable")
        }

        guard let ingredientMeal = try await IngredientMeal.query(on: req.db)
            .filter(\.$meal.$id == mealId)
            .filter(\.$ingredient.$id == ingredientId)
            .first()
        else {
            throw Abort(.notFound, reason: "table intermédiaire d'ingrédients et repas introuvable pour ce repas")
        }
        let updatedMeal = try req.content.decode(UpdateIngredientMealDTO.self)
        
        if let newQuantity = updatedMeal.quandtity{
            
            if newQuantity == 0{
                try await ingredientMeal.delete(on: req.db)
                return Response(status: .noContent)
            }
            else{
                ingredientMeal.quantity = newQuantity
            }
        }
        
        try await ingredientMeal.save(on: req.db)
        return try await ingredientMeal.toDTO().encodeResponse(for: req)
    }
    
   
    @Sendable
    func deleteIngredientMeal(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let mealIdString = req.parameters.get("mealId"),
              let mealId = UUID(uuidString: mealIdString) else {
            throw Abort(.badRequest, reason: "id de repas invalide")
        }
        
       
        guard let ingredientIdString = req.parameters.get("ingredientId"),
              let ingredientId = UUID(uuidString: ingredientIdString) else {
            throw Abort(.badRequest, reason: "id d'ingredient invalide")
        }
        
        guard let _ = try await Ingredient.find(ingredientId, on: req.db) else {
            throw Abort(.notFound, reason: "ingredient introuvable")
        }

        guard let ingredientMeal = try await IngredientMeal.query(on: req.db)
            .filter(\.$meal.$id == mealId)
            .filter(\.$ingredient.$id == ingredientId)
            .first()
        else {
            throw Abort(.notFound, reason: "table intermédiaire d'ingrédients et repas introuvable pour ce repas")
        }
        
        try await ingredientMeal.delete(on: req.db)
        return .noContent
    }
}
