//
//  HometownView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import SwiftUI

struct HometownView: View {
    @EnvironmentObject var coordinator: TabCoordinator
    @StateObject var playlistVM = PlaylistViewModel()
    var body: some View {
        if let hometownId = coordinator.userViewModel.user?.hometownId {
            CityPlaylist(playlistVM: playlistVM)
                .task {
                    guard playlistVM.city == nil else { return }
                    if let city = await City.fetch(id: hometownId) {
                        playlistVM.city = city
                    }
                }
        } else {
            HometownMissingView()
        }
    }
}

struct HometownView_Previews: PreviewProvider {
    static var previews: some View {
        HometownView()
    }
}
