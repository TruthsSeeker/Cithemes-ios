//
//  City.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 10/05/2022.
//

import Foundation

struct City: Identifiable, Codable {
    var id: Int?
    var country: String
    var iso2: String
    var name: String
    @StringURL var image: URL?
    var population: Int
    var spotifyURI: String?
    
    enum CodingKeys: String, CodingKey {
        case id, country, iso2, name, image, population
        case spotifyURI = "playlist_id"
    }
    
    static func fetch(id: Int) async -> City? {
        guard let url = URL.getUrl(for: "/cities/\(id)") else { return nil }
        let request = URLRequest(url: url)
        do {
            let publisher = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<City>.self)
            let city = try await publisher.singleOutput().result
            return city
        } catch(let error) {
            print(error)
        }
        return nil
    }
}
