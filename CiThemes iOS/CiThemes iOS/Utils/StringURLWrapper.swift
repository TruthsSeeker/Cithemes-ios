//
//  StringURLWrapper.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 22/03/2022.
//

import Foundation

@propertyWrapper
struct StringURL: Codable {
    var wrappedValue: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String?.self) {
            wrappedValue = URL(string: value)
        } else {
            wrappedValue = nil
        }
        
    }
    
    init(wrappedValue: URL?) {
        self.wrappedValue = wrappedValue
    }
}
