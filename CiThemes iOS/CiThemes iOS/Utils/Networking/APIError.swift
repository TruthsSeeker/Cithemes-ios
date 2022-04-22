//
//  APIError.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 18/04/2022.
//

import Foundation

enum APIError: LocalizedError {
    case httpError(Int)
    case invalidURL
    case invalidAuth
    case loginRequired
    case other
}
