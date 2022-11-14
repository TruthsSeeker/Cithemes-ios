//
//  SongInfoFull.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import Foundation

struct SongInfo: Codable, Identifiable {
    @StringID var id: String?
    var title: String? = nil
    var artist: String? = nil
    var album: String? = nil
    var release: String? = nil
    var duration: Int? = nil
    @StringURL var preview: URL? = nil
    @StringURL var cover: URL? = nil
    var spotifyID: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case spotifyID = "spotify_id"
        case id, title, artist, album, release, duration, preview, cover
    }
}

extension SongInfo {
    static var example = SongInfo(id: "1", title: "Under the Bridge", artist: "Red Hot Chili Peppers", album: "Blood Sugar Sex Magik", release: "1991", duration: 283000, cover: URL(string: "https://en.wikipedia.org/wiki/Blood_Sugar_Sex_Magik#/media/File:RHCP-BSSM.jpg"))
}
