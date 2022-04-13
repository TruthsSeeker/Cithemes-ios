//
//  User.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var email: String
    var tokens: UserToken?
}
