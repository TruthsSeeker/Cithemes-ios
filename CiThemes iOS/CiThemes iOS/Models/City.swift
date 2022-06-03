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
}
