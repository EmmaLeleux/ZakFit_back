//
//  PhysiqueActivityController.swift
//  ZakFit_back
//
//  Created by Emma on 26/11/2025.
//

import Fluent
import Vapor
import JWT


struct PhysiqueActivityController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("physique-activity")
        
        
        //routes privées
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.post(use: self.createPhysiqueActivity)
        protectedRoutes.delete(":id", use: deleteActivity)
        protectedRoutes.get(use: self.getActivityByUser)
        protectedRoutes.get("date", use: getActivityByDate)
   
        
    }
    
    @Sendable
    func createPhysiqueActivity(req: Request) async throws -> PhysiqueActivityResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let activity = try req.content.decode(CreatePhysiqueActivityDTO.self).toModel()
        
        activity.$user.id = payload.id
        
        try await activity.save(on: req.db)
        
        return activity.toDTO()
    }
    
    
    @Sendable
    func getActivityByUser(req: Request) async throws -> [PhysiqueActivityResponseDTO] {
        let payload = try req.auth.require(UserPayload.self)

        let activity = try await PhysiqueActivity.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .all()
        
        return activity.map{$0.toDTO()}
    }
    
    @Sendable
    func getActivityByDate(req: Request) async throws -> [PhysiqueActivityResponseDTO] {
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
        
        let activity = try await PhysiqueActivity.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .filter(\.$date >= startOfDay)
            .filter(\.$date < endOfDay)
            .all()
        
        return activity.map{$0.toDTO()}
    }
    
    
    @Sendable
    func deleteActivity(req: Request) async throws -> HTTPStatus {
        try req.auth.require(UserPayload.self)
        
        guard let activity = try await PhysiqueActivity.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await activity.delete(on: req.db)
        return .noContent
    }
}
