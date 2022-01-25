//
//  SongInfoFull.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import Foundation

struct SongInfo: Codable, Identifiable {
    var id: String
    var title: String? = nil
    var artist: String? = nil
    var album: String? = nil
    var score: Int = 0
    var release: String? = nil
    var duration: String? = nil
    var preview: URL? = nil
    var originalSuggestion: String? = nil
    var spotifyURI: URL? = nil
    var albumCoverURL: URL? = nil
}
