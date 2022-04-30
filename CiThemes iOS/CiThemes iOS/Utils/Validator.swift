//
//  Validator.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 14/04/2022.
//

import Foundation

class Validator {
    
    
    static let emailRegex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
    static let passwordRegex = #".{8,}"#
    
    static let standard: Validator = Validator()
    
    private init() {}
    
    func validate(_ string: String, regex: String) -> Bool {
        guard let result = string.range(of: regex, options: .regularExpression) else { return false }
        return !result.isEmpty
    }
}
