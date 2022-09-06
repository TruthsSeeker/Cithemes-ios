//
//  HometownView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import SwiftUI

struct HometownView: View {
    var hometownId: Int?
//    @EnvironmentObject var coordinator: RootCoordinator
    @StateObject var playlistVM = PlaylistViewModel()
    var body: some View {
        CityPlaylist(playlistVM: playlistVM)
            .task {
                print("hiiiii")
//                guard playlistVM.city == nil else { return }
                guard playlistVM.city == nil || playlistVM.city?.id != hometownId else { return }
                guard let hometownId = hometownId else { return }
                if let city = await City.fetch(id: hometownId) {
                    playlistVM.city = city
                    playlistVM.fetch()
                }
            }
            .conditional(hometownId == nil) {
                HometownMissingView()
            }
    }
}

struct HometownView_Previews: PreviewProvider {
    static var previews: some View {
        HometownView()
    }
}
