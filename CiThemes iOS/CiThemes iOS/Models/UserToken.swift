//
//  UserToken.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 13/04/2022.
//

import Foundation

struct UserToken: Codable {
    @JWT var accessToken: AccessToken
    @JWT var refreshToken: RefreshToken
    var hometownId: Int?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case hometownId = "hometown_id"
    }
}
