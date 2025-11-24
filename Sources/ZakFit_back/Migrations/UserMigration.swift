//
//  UserMigration.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Fluent

struct UserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("user")
            .id()
            .field("lastname", .string, .required)
            .field("firstname", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("birthday", .datetime, .required)
            .field("profil_picture", .string, .required)
            .field("weight", .double, .required)
            .field("height", .int, .required)
            .field("notifHour", .datetime, .required)
            .field("typeWeightObj", .string, .required)
            .field("sportObj", .string, .required)
            .field("calburnobj", .int, .required)
            .field("timingCal", .string, .required)
            .field("startDate", .datetime, .required)
            .field("finalDate", .datetime, .required)
            .field("timingTraining", .string, .required)
            .field("nbTraining", .int, .required)
            .field("trainingDuration", .int, .required)
            .field("calByDay", .int, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("user").delete()
    }
}
