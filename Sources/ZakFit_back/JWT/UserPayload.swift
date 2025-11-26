//
//  UserPayload.swift
//  ZakFit_back
//
//  Created by Emma on 24/11/2025.
//

import Vapor
import JWT


struct UserPayload : JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        if self.expiration < Date(){
            throw JWTError.invalidJWK
        }
    }
    
    init(id: UUID) {
        self.id = id
        //token expire tout les 7 jours
        self.expiration = Date().addingTimeInterval(3600 * 24 * 7)
    }
    
}

