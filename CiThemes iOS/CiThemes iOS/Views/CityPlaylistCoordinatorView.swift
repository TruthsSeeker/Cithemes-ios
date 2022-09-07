//
//  CityPlaylistCoordinatorView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 07/09/2022.
//

import SwiftUI

struct CityPlaylistCoordinatorView: View {
    @ObservedObject var coordinator: PlaylistCoordinator
    @FocusState var isFocused: Bool
    var body: some View {
        ZStack {
            CityPlaylist(playlistVM: coordinator.playlistVM)
                .sheet(item: $coordinator.searchVM, onDismiss: {
                    coordinator.searchVM = nil
                    coordinator.playlistVM.fetch()
                }, content: { vm in
                    if let city = coordinator.playlistVM.city {
                        SongSearchCoordinatorView(coordinator: SongSearchCoordinator(city: city, parent: coordinator))
                        
                    }
                })
            if let vm = coordinator.detailVM {
                SongDetails(songVM: vm)
                    .edgesIgnoringSafeArea([.top,.bottom])
            }
        }
    }
}

struct CityPlaylistCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CityPlaylistCoordinatorView(coordinator: PlaylistCoordinator(parent: RootCoordinator(), city: City.placeholder))
    }
}
