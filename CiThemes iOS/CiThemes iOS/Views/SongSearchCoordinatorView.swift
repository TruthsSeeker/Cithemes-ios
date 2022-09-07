//
//  SongSearchController.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/01/2022.
//

import SwiftUI

struct SongSearchCoordinatorView: View {
//    @ObservedObject var searchVM: SongSearchViewModel = SongSearchViewModel()
    @ObservedObject var coordinator: SongSearchCoordinator
    @State private var detailsShown = false
    @State private var shownItem: PlaylistEntry?
    @FocusState var isSearchFocused: Bool
    @EnvironmentObject var playlistContext: PlaylistViewModel
    
    var body: some View {
        ZStack(alignment: .top){
            Color.background
            SongSearch(isSearchFocused: _isSearchFocused, searchVM: coordinator.searchVM)

            if let item = coordinator.detailedSong {
                SongDetails(songVM: SongDetailViewModel(entry: item, coordinator: coordinator))
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .background(Color.background)
        
    }
}
