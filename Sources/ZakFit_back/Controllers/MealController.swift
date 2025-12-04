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
        protectedRoutes.patch(":id", use: updateMeal)
        protectedRoutes.get(use: self.getMealsByUser)
        protectedRoutes.get("date", use: getMealsForOneDay)
        protectedRoutes.get(":id", use: getMealById)
        
        let calories = protectedRoutes.grouped("calories")
        
        calories.get(":mealId", use: getMealCalories)
        calories.get(":mealId", "ingredient", ":ingredientId", use: getIngredientCalories)
        
        let lipides = protectedRoutes.grouped("lipides")
        
        lipides.get(":mealId", use: getMealLipides)
        lipides.get(":mealId", "ingredient", ":ingredientId", use: getIngredientLipides)
        
        let glucides = protectedRoutes.grouped("glucides")
        
        glucides.get(":mealId", use: getMealGlucides)
        glucides.get(":mealId", "ingredient", ":ingredientId", use: getIngredientGlucides)
        
        
        let proteine = protectedRoutes.grouped("proteine")
        
        proteine.get(":mealId", use: getMealProteines)
        proteine.get(":mealId", "ingredient", ":ingredientId", use: getIngredientProteines)
   
        
        
    }
    
    @Sendable
    func createMeal(req: Request) async throws -> MealResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let meal = try req.content.decode(CreateMealDTO.self).toModel()
        
        
        meal.$user.id = payload.id
        
        
        try await meal.save(on: req.db)
        try await meal.$ingredients.load(on: req.db)
        return try await meal.toDTO(on: req.db)
    }
    
    @Sendable
    func getMealById(req: Request) async throws -> MealResponseDTO {
        try req.auth.require(UserPayload.self)
        
        guard let meal = try await Meal.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return try await meal.toDTO(on: req.db)
    }
    
    @Sendable
    func getMealCalories(req: Request) async throws -> Int {
        try req.auth.require(UserPayload.self)

        guard let meal = try await Meal.find(req.parameters.get("mealId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await meal.$ingredients.load(on: req.db)
    var totalCalories: Int = 0
    
    for ingredient in meal.ingredients {
        guard let ingredientMeal = try await IngredientMeal.query(on: req.db)
            .filter(\.$meal.$id == meal.requireID())
            .filter(\.$ingredient.$id == ingredient.requireID())
            .first()
        else {
            throw Abort(.notFound, reason: "table intermédiaire d'ingrédients et repas introuvable pour ce repas")
        }
        
        totalCalories += ingredientMeal.quantity * ingredient.cal
    }
 return totalCalories
    }
    
  
    
    @Sendable
    func getMealGlucides(req: Request) async throws -> Int {
        try req.auth.require(UserPayload.self)

        guard let meal = try await Meal.find(req.parameters.get("mealId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await meal.$ingredients.load(on: req.db)
    var totalCalories: Int = 0
    
    for ingredient in meal.ingredients {
        guard let ingredientMeal = try await IngredientMeal.query(on: req.db)
            .filter(\.$meal.$id == meal.requireID())
            .filter(\.$ingredient.$id == ingredient.requireID())
            .first()
        else {
            throw Abort(.notFound, reason: "table intermédiaire d'ingrédients et repas introuvable pour ce repas")
        }
        
        totalCalories += ingredientMeal.quantity * ingredient.glucide
    }
 return totalCalories
    }
    
    
    @Sendable
    func getMealProteines(req: Request) async throws -> Int {
        try req.auth.require(UserPayload.self)

        guard let meal = try await Meal.find(req.parameters.get("mealId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await meal.$ingredients.load(on: req.db)
    var totalCalories: Int = 0
    
    for ingredient in meal.ingredients {
        guard let ingredientMeal = try await IngredientMeal.query(on: req.db)
            .filter(\.$meal.$id == meal.requireID())
            .filter(\.$ingredient.$id == ingredient.requireID())
            .first()
        else {
            throw Abort(.notFound, reason: "table intermédiaire d'ingrédients et repas introuvable pour ce repas")
        }
        
        totalCalories += ingredientMeal.quantity * ingredient.protein
    }
 return totalCalories
    }
    
    @Sendable
    func getMealLipides(req: Request) async throws -> Int {
        try req.auth.require(UserPayload.self)

        guard let meal = try await Meal.find(req.parameters.get("mealId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await meal.$ingredients.load(on: req.db)
    var totalCalories: Int = 0
    
    for ingredient in meal.ingredients {
        guard let ingredientMeal = try await IngredientMeal.query(on: req.db)
            .filter(\.$meal.$id == meal.requireID())
            .filter(\.$ingredient.$id == ingredient.requireID())
            .first()
        else {
            throw Abort(.notFound, reason: "table intermédiaire d'ingrédients et repas introuvable pour ce repas")
        }
        
        totalCalories += ingredientMeal.quantity * ingredient.carbonhydrate
    }
 return totalCalories
    }
    
    @Sendable
    func getIngredientCalories(req: Request) async throws -> Int {
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
        
        return ingredient.cal * ingredientMeal.quantity
    }
    
    @Sendable
    func getIngredientGlucides(req: Request) async throws -> Int {
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
        
        return ingredient.glucide * ingredientMeal.quantity
    }
    
    @Sendable
    func getIngredientProteines(req: Request) async throws -> Int {
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
        
        return ingredient.protein * ingredientMeal.quantity
    }
    
    @Sendable
    func getIngredientLipides(req: Request) async throws -> Int {
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
        
        return ingredient.carbonhydrate * ingredientMeal.quantity
    }


    
    @Sendable
    func getMealsByUser(req: Request) async throws -> [MealResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)

        let meals = try await Meal.query(on: req.db)
            .with(\.$ingredients)
            .filter(\.$user.$id == payload.id)
            .all()
        
        var mealDTOs: [MealResponseDTO] = []
        for meal in meals {
            let dto = try await meal.toDTO(on: req.db)
            mealDTOs.append(dto)
        }
        return mealDTOs
    }
    
    @Sendable
    func updateMeal(req: Request) async throws -> MealResponseDTO {
        try req.auth.require(UserPayload.self)
        
        guard let meal = try await Meal.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedMeal = try req.content.decode(UpdateMealDTO.self)
        
        if let newType = updatedMeal.type{
            meal.type = newType
        }
        
        try await meal.save(on: req.db)
        try await meal.$ingredients.load(on: req.db)
        return try await meal.toDTO(on: req.db)
    }
    
    @Sendable
    func getMealsForOneDay(req: Request) async throws -> [MealResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)

        guard let dateString = try? req.query.get(String.self, at: "date") else {
            throw Abort(.badRequest, reason: "date manquante")
        }
        
     
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let day = formatter.date(from: dateString) else {
            throw Abort(.badRequest, reason: "date invalide")
        }
        

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: day)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let meals = try await Meal.query(on: req.db)
            .with(\.$ingredients)
            .filter(\.$user.$id == payload.id)
            .filter(\.$date >= startOfDay)
            .filter(\.$date < endOfDay)
            .all()
        
        var mealDTOs: [MealResponseDTO] = []
        for meal in meals {
            let dto = try await meal.toDTO(on: req.db)
            mealDTOs.append(dto)
        }
        return mealDTOs
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
