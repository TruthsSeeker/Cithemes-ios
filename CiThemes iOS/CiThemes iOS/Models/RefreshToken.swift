//
//  RefreshToken.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/04/2022.
//

import Foundation

struct RefreshToken: Codable {
    var iat: Int
    var exp: Int
    var userId: Int
    var jwtId: String
    var hometownId: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case jwtId = "jwtid"
        case hometownId = "hometown_id"
        case iat, exp
    }
}
