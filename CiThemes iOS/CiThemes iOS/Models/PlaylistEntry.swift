//
//  PlaylistEntry.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 21/03/2022.
//

import Foundation

struct PlaylistEntry: Codable, Identifiable {
    var id: Int
    var songInfo: SongInfo? = nil
    var votes: Int = 0
    var cityId: String? = nil
}
