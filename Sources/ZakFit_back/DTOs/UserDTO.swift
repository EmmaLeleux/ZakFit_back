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
        model.birthday = birthday
        model.profil_picture = profil_picture
        model.weight = weight
        model.height = height
        model.notifHour = notifHour
        model.typeWeightObj = typeWeightObj
        model.sportObj = sportObj
        model.calburnobj = calburnobj
        model.timingCal = timingCal
        model.startDate = startDate
        model.finalDate = finalDate
        model.timingTraining = timingTraining
        model.nbTraining = nbTraining
        model.trainingDuration = trainingDuration
        model.calByDay = calByDay
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
