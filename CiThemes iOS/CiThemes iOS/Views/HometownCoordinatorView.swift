//
//  HometownView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import SwiftUI

struct HometownCoordinatorView: View {
    @EnvironmentObject var coordinator: HometownCoordinator
    @StateObject var playlistVM = PlaylistViewModel()
    var body: some View {
        CityPlaylist(playlistVM: playlistVM)
            .task {
                guard playlistVM.city == nil else { return }
                guard let hometownId = coordinator.hometownId else { return }
                if let city = await City.fetch(id: hometownId) {
                    playlistVM.city = city
                    playlistVM.fetch()
                }
            }
            .conditional(coordinator.hometownId != nil) {
                HometownMissingView()
            }
    }
}

struct HometownView_Previews: PreviewProvider {
    static var previews: some View {
        HometownCoordinatorView()
    }
}
