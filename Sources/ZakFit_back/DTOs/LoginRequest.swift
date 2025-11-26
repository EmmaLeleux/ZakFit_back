//
//  LoginRequest.swift
//  ZakFit_back
//
//  Created by Emma on 25/11/2025.
//

import Vapor

struct LoginRequest : Content {
    let email : String
    let password : String
}


struct LoginResponse: Content {
    let token: String
    let user: UserResponseDTO
}
