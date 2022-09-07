//
//  SongSearchCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 06/09/2022.
//

import Foundation

class SongSearchCoordinator: ObservableObject, UserViewCoordinator, SongDetailsCoordinator {
    
    
    private unowned let parent: UserViewCoordinator
    @Published var searchVM: SongSearchViewModel!
    @Published var detailedSong: PlaylistEntry?
    
    init(city: City, parent: UserViewCoordinator) {
        self.parent = parent
        self.searchVM = SongSearchViewModel(city: city, coordinator: self)
    }
    
    func toggleLogin() {
        parent.toggleLogin()
    }
    
    func displayError(message: String) {
        parent.displayError(message: message)
    }
    func setDetail(for entry: PlaylistEntry) {
        detailedSong = entry
    }
    
    func dismissDetails() {
        detailedSong = nil
    }
    
}
