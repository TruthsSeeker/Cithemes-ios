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
        let now = Date().timeIntervalSince1970.millisecond
        return exp > now
    }
}
