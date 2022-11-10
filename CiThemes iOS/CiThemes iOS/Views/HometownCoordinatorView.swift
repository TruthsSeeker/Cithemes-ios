//
//  HometownView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//
// There's something I don't understand about the way coordinators are created, updated and notify changes here

import SwiftUI

struct HometownCoordinatorView: View {
    var hometown: Hometown?
    @EnvironmentObject var coordinator: PlaylistCoordinator
    @FocusState var isFocused
    
    var body: some View {
        ZStack {
            EmptyView()
                // Display City Playlist once playlistVM is set
                // Depending on playlistVM here triggers the reload once the VM is set
            .conditional(coordinator.playlistVM != nil) {
                CityPlaylist(playlistVM: coordinator.playlistVM!)
            }
            .sheet(item: $coordinator.searchVM, onDismiss: {
                coordinator.searchVM = nil
                coordinator.playlistVM?.fetch()
                }, content: { vm in
                    if let city = coordinator.playlistVM?.city {
                        SongSearchCoordinatorView(
                            coordinator: SongSearchCoordinator(
                                city: city,
                                parent: coordinator)
                        )
                    }
                }
            )
            if let vm = coordinator.detailVM {
                SongDetails(songVM: vm)
                    .edgesIgnoringSafeArea([.top,.bottom])
            }
        }
            .task {
                //TODO: Replace with loading from Core Data
                // If hometownId is set, fetch the corresponding city data
                guard let hometown = hometown else { return }
                if let city = await City.fetch(id: hometown.hometownId) {
                    // Set the playlistVM to trigger a reload
                    coordinator.playlistVM = PlaylistViewModel(city: city, coordinator: coordinator)
                    
                    // TODO: Test if this is required
                    coordinator.playlistVM?.fetch()
                }
            }
            .conditional(hometown == nil) {
                HometownMissingView()
            }
    }
}

struct HometownCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        HometownCoordinatorView()
            .environmentObject(PlaylistCoordinator(parent: RootCoordinator(), city: City.placeholder))
            .environmentObject(RootCoordinator())
    }
}
