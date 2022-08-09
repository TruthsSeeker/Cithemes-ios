//
//  RemoteURL.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/08/2022.
//

import Foundation

protocol RemoteImageURL: Codable, Identifiable {
    var image: URL? {get set}
}
