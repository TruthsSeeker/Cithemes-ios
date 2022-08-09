//
//  StringIDWrapper.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 22/03/2022.
//

import Foundation

@propertyWrapper
struct StringID: Codable {
    var wrappedValue: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int?.self) {
            wrappedValue = String(value)
        } else if let value = try? container.decode(String?.self) {
            wrappedValue = value
        } else if let value = try? container.decode(String.self) {
            wrappedValue = value
        } else if let value = try? container.decode(Int.self) {
            wrappedValue = String(value)
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unable to decode ID", underlyingError: nil))
        }
    }
    
    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }
}
