//
//  SongInfoViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 01/01/2022.
//

import Foundation
import Combine

final class SongListViewModel: ObservableObject {
    enum VoteType {
        case Up
        case Down
    }
    #if DEBUG
    @Published var songsDict: [String:PlaylistEntry] = { count in
        var dict: [String: PlaylistEntry] = [:]
        for song in Array(repeating: 0, count: count).map({ _ in
            return PlaylistEntry(id: UUID().uuidString, songInfo: SongInfo(id: UUID().uuidString, title: String(Int.random(in: 1...100000)), artist: String(Int.random(in: 1...100000))), votes: Int.random(in: 0...1000), cityId: nil)
        }) {
            dict[song.id ?? ""] = song
        }
        return dict
    }(50)
    #else
    @Published var songsDict: [String: SongInfoFull] = [:]
    #endif

    
    func update(id: String, vote: VoteType) {
        if let song = songsDict[id] {
            let newScore = song.votes + (vote == .Down ? -1 : 1)
            songsDict[id]?.votes = newScore
            
        }
    }
    
}
