//
//  ImageCache.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/08/2022.
//

import Foundation

@propertyWrapper
struct ImageCache<T: RemoteImageURL>: Codable {
    var wrappedValue: T
    
    init(from decoder: Decoder) throws {
        guard let wrapped = try? T(from: decoder) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Decoding error in ImageCache wrapper"))
        }
        
        wrappedValue = wrapped
    }
}
