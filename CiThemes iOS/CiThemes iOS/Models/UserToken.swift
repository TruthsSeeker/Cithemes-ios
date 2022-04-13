//
//  UserToken.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 13/04/2022.
//

import Foundation

struct UserToken: Codable {
    let accessToken: String
    let refreshToken: String
}
