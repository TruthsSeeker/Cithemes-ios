//
//  PlaylistCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct PlaylistCell: View {

    let song: PlaylistEntry
    let rank: Int

    @ViewBuilder
    var body: some View {
        switch rank {
        case 0:
            FirstRankCell(entry: song)
        case 1:
            PodiumCell(position: .second, entry: song)
        case 2:
            PodiumCell(position: .third, entry: song)
        default:
            NormalCell(entry: song, rank: rank + 1)
        }
    }
}


struct PlaylistCell_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistCell(song: PlaylistEntry(id: -1, songInfo: SongInfo.example, cityId: -1), rank: 1)
    }
}
