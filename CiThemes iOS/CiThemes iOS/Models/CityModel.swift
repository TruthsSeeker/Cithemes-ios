//
//  City.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 10/05/2022.
//

import Foundation
import CoreData

struct CityModel: RemoteImageURL {
    var id: Int?
    var country: String
    var iso2: String
    var name: String
    @StringURL var image: URL?
    var population: Int
    
}
