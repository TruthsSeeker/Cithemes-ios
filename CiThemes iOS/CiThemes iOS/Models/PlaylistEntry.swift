//
//  PlaylistEntry.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 21/03/2022.
//

import Foundation

struct PlaylistEntry: Codable, Identifiable {
    @StringID var id: String?
    var songInfo: SongInfo
    var votes: Int = 0
    var cityId: Int
    var voted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case songInfo = "song_info"
        case cityId = "city_id"
        case id, votes, voted
    }
}

extension PlaylistEntry: Hashable {
    static func == (lhs: PlaylistEntry, rhs: PlaylistEntry) -> Bool {
        return lhs.id == rhs.id
            && lhs.votes == rhs.votes
            && lhs.voted == rhs.voted
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(votes)
        hasher.combine(voted)
    }
}
