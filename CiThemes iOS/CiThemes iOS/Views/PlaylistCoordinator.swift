//
//  PlaylistCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 06/09/2022.
//

import Foundation

class PlaylistCoordinator: ObservableObject, SongDetailsCoordinator {
    private unowned let parent: UserViewCoordinator
    @Published var playlistVM: PlaylistViewModel!
    @Published var detailedSong: PlaylistEntry?
    @Published var detailVM: SongDetailViewModel?
    @Published var searchVM: SongSearchViewModel?
    
    init(parent: UserViewCoordinator, city: City?) {
        self.parent = parent
        self.playlistVM = PlaylistViewModel(list: [], city: city, coordinator: self)
    }
    
    func dismissDetails() {
        detailVM = nil
    }
    
    func setDetail(for entry: PlaylistEntry) {
        detailVM = SongDetailViewModel(entry: entry, coordinator: self)
    }
    
    func toggleLogin() {
        parent.toggleLogin()
    }
    
    func displayError(message: String) {
        parent.displayError(message: message)
    }
    
    func search(for city: City) {
        self.searchVM = SongSearchViewModel(city: city, coordinator: self)
    }
}
