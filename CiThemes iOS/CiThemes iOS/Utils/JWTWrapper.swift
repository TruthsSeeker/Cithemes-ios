//
//  JWT+Codable.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 18/04/2022.
//

import Foundation

@propertyWrapper
struct JWT<T:Codable>: Codable {
    var wrappedValue: T
    var projectedValue: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            projectedValue = value
            let substr = value.split(separator: ".")
            let padded = String(substr[1]).paddingb64()
            guard substr.count > 1,
                  let data = Data(base64Encoded: padded)
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Malformed JWT"))
            }
            wrappedValue = try JSONDecoder().decode(T.self, from: data)
            
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Expected String"))
        }
    }
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        projectedValue = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(projectedValue)
    }
}


