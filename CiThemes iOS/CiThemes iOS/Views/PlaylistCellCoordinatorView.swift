//
//  PlaylistCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct PlaylistCellCoordinatorView: View {

    let song: PlaylistEntry
    let rank: Int
    @ObservedObject var coordinator: PlaylistCellCoordinator

    @ViewBuilder
    var body: some View {
        Group {
            switch rank {
            case 0:
                FirstRankCell(viewModel: coordinator.song!)
            case 1:
                PodiumCell(position: .second, viewModel: coordinator.song!)
            case 2:
                PodiumCell(position: .third, viewModel: coordinator.song!)
            default:
                NormalCell(viewModel: coordinator.song!, rank: rank + 1)
            }
        }
    }
}


struct PlaylistCell_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistCellCoordinatorView(song: PlaylistEntry(id: -1, songInfo: SongInfo.example, cityId: -1), rank: 1, coordinator: PlaylistCellCoordinator(entry: PlaylistEntry(id: 1, songInfo: SongInfo.example, votes: 345, cityId: 1), parent: RootCoordinator()))
    }
}
