//
//  SongInfoViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 01/01/2022.
//

import Foundation
import Combine

final class SongListViewModel: ObservableObject {
    enum VoteType: Int {
        case Up = 1
        case Down = -1
    }
    
    @Published var cityId: Int
    var songsDict: [PlaylistEntry] {
        didSet {
            songsDict.sort { lhs, rhs in
                lhs.votes > rhs.votes
            }
            objectWillChange.send()
        }
    }
    
    init(list: [PlaylistEntry], cityId: Int) {
        self.songsDict = list
        self.cityId = cityId
    }
    
    
    func update(id: Int, vote: VoteType) {
        guard let index = songsDict.firstIndex(where: { entry in
            entry.id == id
        }) else { return }
        
        songsDict[index] = PlaylistEntry(id: songsDict[index].id, songInfo: songsDict[index].songInfo, votes: songsDict[index].votes + vote.rawValue, cityId: songsDict[index].cityId)
    }
    
    static var placeholder = SongListViewModel(list: Array(repeating: 0, count: 50).map({ _ in
        return PlaylistEntry(id: UUID().hashValue, songInfo: SongInfo(id: UUID().uuidString, title: String(Int.random(in: 1...100000)), artist: String(Int.random(in: 1...100000))), votes: Int.random(in: 0...1000), cityId: nil)
    }), cityId: 1)
}
