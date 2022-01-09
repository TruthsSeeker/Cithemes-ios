//
//  SongInfoFull.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import Foundation

struct SongInfoFull: Codable {
    let id: String?
    let title: String?
    let artist: String?
    let album: String?
    let score: Int?
    let release: String?
    let duration: String?
    let preview: URL?
    let originalSuggestion: String?
    let spotifyURI: URL?
    let albumCoverURL: URL?
    
}

extension SongInfoFull {
    init(light: SongInfoLight) {
        id = light.id
        title = light.title
        artist = light.artist
        score = light.score
        album = nil
        release = nil
        duration = nil
        preview = nil
        originalSuggestion = nil
        spotifyURI = nil
        albumCoverURL = nil
    }
}
