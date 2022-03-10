//
//  RootResponse.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 10/03/2022.
//

import Foundation

struct RootResponse<T: Codable>: Codable {
    var result: T
}
