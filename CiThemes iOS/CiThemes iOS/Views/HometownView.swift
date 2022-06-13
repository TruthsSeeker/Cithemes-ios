//
//  HometownView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import SwiftUI

struct HometownView: View {
    @EnvironmentObject var coordinator: TabCoordinator
    var body: some View {
        if coordinator.userViewModel.user != nil {
            CityPlaylist(playlistVM: PlaylistViewModel())
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
