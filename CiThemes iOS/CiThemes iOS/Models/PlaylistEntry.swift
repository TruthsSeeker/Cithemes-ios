//
//  PlaylistEntry.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 21/03/2022.
//

import Foundation

struct PlaylistEntry: Codable, Identifiable {
    var id: Int
    var songInfo: SongInfo
    var votes: Int = 0
    var cityId: Int
}

extension PlaylistEntry: Hashable {
    static func == (lhs: PlaylistEntry, rhs: PlaylistEntry) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
