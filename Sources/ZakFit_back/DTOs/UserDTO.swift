//
//  UserDTO.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent
import Vapor


struct CreateUserDTO: Content{
    var lastname: String
    var firstname: String
    var email: String
    var password: String
    var birthday: Date
    var profil_picture: String
    var weight: Double
    var height: Int
    var notifHour: Date
    var typeWeightObj: String
    var sportObj: String
    var calburnobj: Int
    var timingCal: String
    var startDate: Date
    var finalDate: Date
    var timingTraining: String
    var nbTraining: Int
    var trainingDuration: Int
    var calByDay: Int
    
    func toModel() -> User {
        let model = User()
        model.id = UUID()
        model.lastname = lastname
        model.firstname = firstname
        model.email = email
        model.password = password
        model.birthday = Date.now
        model.profil_picture = "https://i.ibb.co/8LBChdjz/User-avatar-svg.png"
        model.weight = 70
        model.height = 160
        model.notifHour = Date.now
        model.typeWeightObj = "perdre du poids"
        model.sportObj = "Equitation"
        model.calburnobj = 1000
        model.timingCal = "semaine"
        model.startDate = Date.now
        model.finalDate = Date().addingTimeInterval(7 * 24 * 3600)
        model.timingTraining = "semaine"
        model.nbTraining = 0
        model.trainingDuration = 30
        model.calByDay = 1000
        return model
    }
    
}


struct UpdateUserDTO: Content{
    var lastname: String?
    var firstname: String?
    var email: String?
    var password: String?
    var profil_picture: String?
    var weight: Double?
    var height: Int?
    var notifHour: Date?
    var typeWeightObj: String?
    var sportObj: String?
    var calburnobj: Int?
    var timingCal: String?
    var startDate: Date?
    var finalDate: Date?
    var timingTraining: String?
    var nbTraining: Int?
    var trainingDuration: Int?
    var calByDay: Int?
    
    
}


struct UserResponseDTO: Content{
    var id: UUID
    var lastname: String
    var firstname: String
    var email: String
    var age: Int 
    var profil_picture: String
    var weight: Double
    var height: Int
    var notifHour: Date
    var typeWeightObj: String
    var sportObj: String
    var calburnobj: Int
    var timingCal: String
    var startDate: Date
    var finalDate: Date
    var timingTraining: String
    var nbTraining: Int
    var trainingDuration: Int
    var calByDay: Int
    
    
}
