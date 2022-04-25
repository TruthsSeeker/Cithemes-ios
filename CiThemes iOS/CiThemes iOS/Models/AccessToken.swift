//
//  AccessToken.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/04/2022.
//

import Foundation

struct AccessToken: Codable {
    let iat: Int
    let exp: Int
    
    func isValid() -> Bool {
        let now = Int(Date().timeIntervalSince1970)
        return exp > now
    }
}
