//
//  HometownView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//
// There's something I don't understand about the way coordinators are created, updated and notify changes here

import SwiftUI

struct HometownCoordinatorView: View {
    var hometownId: Int?
    @EnvironmentObject var coordinator: PlaylistCoordinator
    @FocusState var isFocused
    
    var body: some View {
        ZStack {
            EmptyView()
                .conditional(coordinator.playlistVM != nil) {
                    CityPlaylist(playlistVM: coordinator.playlistVM!)
                }
                .sheet(item: $coordinator.searchVM, onDismiss: {
                    coordinator.searchVM = nil
                    coordinator.playlistVM?.fetch()
                }, content: { vm in
                    if let city = coordinator.playlistVM?.city {
                        SongSearchCoordinatorView(coordinator: SongSearchCoordinator(city: city, parent: coordinator))                        
                    }
                })
            if let vm = coordinator.detailVM {
                SongDetails(songVM: vm)
                    .edgesIgnoringSafeArea([.top,.bottom])
            }
        }
            .task {
                guard let hometownId = hometownId else { return }
                if let city = await City.fetch(id: hometownId) {
                    coordinator.playlistVM = PlaylistViewModel(city: city, coordinator: coordinator)
                    print(city)
                    coordinator.playlistVM?.fetch()
                }
            }
            .conditional(hometownId == nil) {
                HometownMissingView()
            }
    }
}

struct HometownView_Previews: PreviewProvider {
    static var previews: some View {
        HometownCoordinatorView()
    }
}
