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
    @Published var songsDict: [String:SongInfoLight] = { count in
        var dict: [String: SongInfoLight] = [:]
        for song in Array(repeating: 0, count: count).map({ _ in
            return SongInfoLight(id: UUID().uuidString, title: String(Int.random(in: 1...100000)), artist: String(Int.random(in: 1...100000)), score: Int.random(in: 0...1000))
        }) {
            dict[song.id] = song
        }
        return dict
    }(50)
    #else
    @Published var songsDict: [String: SongInfoLight] = [:]
    #endif

    
    func update(id: String, vote: VoteType) {
        if let song = songsDict[id] {
            let newScore = song.score + (vote == .Down ? -1 : 1)
            songsDict[id] = SongInfoLight(id: song.id, title: song.title, artist: song.artist, score: newScore)
            
        }
    }
    
}
