//
//  PlaylistCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct PlaylistCell: View {
    enum CellStyle: Int {
        case first = 0, second, third
    }

    let style: PlaylistCell.CellStyle?
    let song: PlaylistEntry

    @ViewBuilder
    var body: some View {
        switch style {
        case .first:
            FirstRankCell(song: song, vote: {})
        case .second:
            PodiumCell(position: .second, song: song, vote: {})
        case .third:
            PodiumCell(position: .third, song: song, vote: {})
        case nil:
            NormalCell(song: song, vote: {})
        }
    }
}


struct PlaylistCell_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistCell(style: .first, song: PlaylistEntry(id: 0))
    }
}
