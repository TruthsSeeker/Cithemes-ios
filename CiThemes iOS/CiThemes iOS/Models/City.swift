//
//  City.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 10/05/2022.
//

import Foundation

struct City: Identifiable, Codable {
    @StringID var id: String?
    var country: String
    var countryISO: String
    var name: String
    @StringURL var image: URL?
    //TODO: Bounds
}
