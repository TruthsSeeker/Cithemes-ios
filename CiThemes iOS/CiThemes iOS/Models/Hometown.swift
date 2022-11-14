//
//  Hometown.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 03/11/2022.
//

import Foundation

struct Hometown: Codable {
    var hometownId: Int
    var name: String
    var country: String
    @StringURL var image: URL?
    var lastUpdate: Date
    
    enum CodingKeys: String, CodingKey {
        case hometownId = "hometown_id"
        case lastUpdate = "updated_at"
        case name, country, image
    }
    
    static func fetch(id: Int?) async -> Hometown? {
        guard let id, let url = URL.getUrl(for: "/auth/hometown/\(id)") else { return nil }
        let request = URLRequest(url: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let publisher = NetworkManager.shared.authenticatedRequestPublisher(for: request, decoding: RootResponse<Hometown>.self, withDecoder: decoder)
            let hometown = try await publisher.singleOutput().result
            return hometown
        } catch(let error) {
            print(error)
        }
        return nil
    }

}
