//
//  User.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//



import Fluent
import Vapor

final class User: Model, @unchecked Sendable, Content {
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "lastname")
    var lastname: String
    
    @Field(key: "firstname")
    var firstname: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "birthday")
    var birthday: Date
    
    @Field(key: "profil_picture")
    var profil_picture: String
    
    @Field(key: "weight")
    var weight: Double
    
    @Field(key: "height")
    var height: Int
    
    @Field(key: "notifHour")
    var notifHour: Date
    
    @Field(key: "typeWeightObj")
    var typeWeightObj: String
    
    @Field(key: "sportObj")
    var sportObj: String
    
    @Field(key: "calburnobj")
    var calburnobj: Int
    
    @Field(key: "timingCal")
    var timingCal: String
    
    @Field(key: "startDate")
    var startDate: Date
    
    @Field(key: "finalDate")
    var finalDate: Date
    
    @Field(key: "timingTraining")
    var timingTraining: String
    
    @Field(key: "nbTraining")
    var nbTraining: Int
    
    @Field(key: "trainingDuration")
    var trainingDuration: Int
    
    @Field(key: "calByDay")
    var calByDay: Int
    
    @Field(key: "genre")
    var genre: String
    
    @Field(key: "objLipides")
    var objLipides: Int
    
    @Field(key: "objGlucides")
    var objGlucides: Int
    
    @Field(key: "objProtein")
    var objProtein: Int
    
    @Field(key: "frequenceEntrainement")
    var frequenceEntrainement: Int
    
    @Field(key: "minProgression")
    var minProgression: Int
    
    @Field(key: "timingProgression")
    var timingProgression: String
    
    @Field(key: "isOnBoardCompleted")
    var isOnBoardCompleted: Bool
    
    @Children(for: \.$user) var diets: [Diet]
    @Children(for: \.$user) var meals: [Meal]
    @Children(for: \.$user) var physiqueActivitys: [PhysiqueActivity]
    @Children(for: \.$user) var weights: [Weight]
    @OptionalChild(for: \.$user) var weightObj: WeightObjectif?
    
    

    init() {}
    
    
    func toDTO() -> UserResponseDTO{
        
        let age = Calendar.current.dateComponents([.year], from: self.birthday, to: Date()).year ?? 0
        //permet de récuperer que l'âge de l'user

        return UserResponseDTO(
            id: self.id ?? UUID(),
            lastname: self.lastname,
            firstname: self.firstname,
            email: self.email,
            age: age,
            profil_picture: self.profil_picture,
            weight: self.weight,
            height: self.height,
            notifHour: self.notifHour,
            typeWeightObj: self.typeWeightObj,
            sportObj: self.sportObj,
            calburnobj: self.calburnobj,
            timingCal: self.timingCal,
            startDate: self.startDate,
            finalDate: self.finalDate,
            timingTraining: self.timingTraining,
            nbTraining: self.nbTraining,
            trainingDuration: self.trainingDuration,
            calByDay: self.calByDay,
            genre: self.genre,
            objLipides: self.objLipides,
            objProtein: self.objProtein,
            objGlucides: self.objGlucides,
            frequenceEntrainement: self.frequenceEntrainement,
            minProgression: self.minProgression,
            timingProgression: self.timingProgression,
            isOnBoardCompleted: self.isOnBoardCompleted
        )
    }
}
