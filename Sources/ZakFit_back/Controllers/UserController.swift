//
//  UserController.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//
import Fluent
import Vapor
import JWT


struct UserController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let user = routes.grouped("user")
        
        
        //routes  public
        user.post(use: createUser)
        user.post("login", use: login)
        user.get("All", use: self.index)
        
        
        //routes privées`
        let protectedRoutes = user.grouped(JWTMiddleware())
        protectedRoutes.patch(use: self.updateUser)
        protectedRoutes.delete(use: deleteUser)
        protectedRoutes.get("me", use: getMyUser)
        protectedRoutes.patch("infos", use: updateUserInfo)
        
        
      
        
        
        
        
    }
    
    @Sendable
    func index(req: Request) async throws -> [UserResponseDTO] {
        
        let users = try await User.query(on: req.db)
            .all()
            
        
            return users.map { $0.toDTO() }
    }
    
    
    @Sendable
    func getMyUser(req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        return user.toDTO()
    }
    
    @Sendable
    func createUser(req: Request) async throws -> LoginResponse {
        let user = try req.content.decode(CreateUserDTO.self).toModel()
        
        user.password = try Bcrypt.hash(user.password)
        
        let existing = try await User.query(on: req.db)
        
            .filter(\.$email == user.email)
            .first()
        if existing != nil {
            throw Abort(.badRequest, reason: "Username already taken")
        }
        
        try await user.save(on: req.db)
        
        let payload = UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: "ZaaaaakFitMonpote")
        let token = try signer.sign(payload)
        
        return LoginResponse(token: token, user: user.toDTO())
    }
    
    @Sendable
    func login(req: Request) async throws -> LoginResponse {
        let userData = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Unknow User")
        }
        
        guard try Bcrypt.verify(userData.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Password incorect")
        }
        
        let payload = UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: "ZaaaaakFitMonpote")
        let token = try signer.sign(payload)
        
        return LoginResponse(token: token, user: user.toDTO())
    }
    
    
    
    @Sendable
    func updateUser(_ req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        let updatedUser = try req.content.decode(UpdateUserDTO.self)
        
        if let newLastname = updatedUser.lastname {
            user.lastname = newLastname
        }
        
        if let newFirstname = updatedUser.firstname{
            user.firstname = newFirstname
        }
        
        if let newEmail = updatedUser.email{
            user.email = newEmail
        }
        
        if let newPassword = updatedUser.password{
            user.password = newPassword
        }
        
        if let newProfilPicture = updatedUser.profil_picture{
            user.profil_picture = newProfilPicture
        }
        
        if let newBirthday = updatedUser.birthday{
            user.birthday = newBirthday
        }
        
        if let newGenre = updatedUser.genre{
            user.genre = newGenre
        }
        
        if let newWeight = updatedUser.weight{
            user.weight = newWeight
        }
        
        if let newHeight = updatedUser.height{
            user.height = newHeight
        }
        
        if let newNotifHour = updatedUser.notifHour{
            user.notifHour = newNotifHour
        }
        
        if let newTypeWeightObj = updatedUser.typeWeightObj{
            user.typeWeightObj = newTypeWeightObj
        }
        
        if let sportObj = updatedUser.sportObj{
            user.sportObj = sportObj
        }
        
        if let calburnobj = updatedUser.calburnobj{
            user.calburnobj = calburnobj
        }
        
        if let newTimingCal = updatedUser.timingCal{
            user.timingCal = newTimingCal
        }
        
        if let newStartDate = updatedUser.startDate{
            user.startDate = newStartDate
        }
        
        if let newFinalDate = updatedUser.finalDate{
            user.finalDate = newFinalDate
        }
        
        if let newTimingTraining = updatedUser.timingTraining{
            user.timingTraining = newTimingTraining
        }
        
        if let newNbTraining = updatedUser.nbTraining{
            user.nbTraining = newNbTraining
        }
        
        if let newTrainingDuration = updatedUser.trainingDuration{
            user.trainingDuration = newTrainingDuration
        }
        
        if let newCalByDay = updatedUser.calByDay{
            user.calByDay = newCalByDay
        }
        
        if let newObjLipides = updatedUser.objLipides{
            user.objLipides = newObjLipides
        }
        
        if let newObjProtein = updatedUser.objProtein{
            user.objProtein = newObjProtein
        }
        
        if let newGlucides = updatedUser.objGlucides{
            user.objGlucides = newGlucides
        }
        
        if let newFrequence = updatedUser.frequenceEntrainement{
            user.frequenceEntrainement = newFrequence
        }

        if let newMinProgression = updatedUser.minProgression{
            user.minProgression = newMinProgression
        }
        
        if let newTimingProgression = updatedUser.timingProgression{
            user.timingProgression = newTimingProgression
        }
        
        if let newOnboard = updatedUser.isOnBoardCompleted{
            user.isOnBoardCompleted = newOnboard
        }

        
        try await user.save(on: req.db)
        
        return user.toDTO()
    }
    
    
    @Sendable
    func updateUserInfo(_ req: Request) async throws -> UserResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        let updatedUser = try req.content.decode(UpdateUserInfoDTO.self)
        
        if let newMdp = updatedUser.newMdp{
            guard try Bcrypt.verify(updatedUser.mdpActuel ?? "", created: user.password) else {
                throw Abort(.unauthorized, reason: "Password incorect")
            }
        }
        
        
        if let newLastname = updatedUser.lastname {
            user.lastname = newLastname
        }
        
        if let newFirstname = updatedUser.firtsname{
            user.firstname = newFirstname
        }
        
        if let newEmail = updatedUser.email{
            user.email = newEmail
        }
        
        if let newPassword = updatedUser.newMdp{
            user.password = try Bcrypt.hash(newPassword)
        }
        
       
        
        try await user.save(on: req.db)
        
        return user.toDTO()
    }
    @Sendable
    func deleteUser(_ req: Request) async throws -> HTTPStatus {
        
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$id == payload.id).first() else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        try await user.delete(on: req.db)
        
        return .noContent
    }
    
    
}
