//
//  SongDetailCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 05/09/2022.
//

import Foundation

class SongDetailCoordinator: ObservableObject, UserViewCoordinator {
    private unowned let parent: RootCoordinator
    @Published var songVM: SongDetailViewModel?
    
    init(entry: PlaylistEntry, parent: RootCoordinator){
        self.parent = parent
        self.songVM = SongDetailViewModel(entry: entry, coordinator: self)
    }
    
    func toggleLogin() {
        parent.toggleLogin()
    }
    
    func displayError(message: String) {
        parent.displayError(message: message)
    }
    
    func hideDetails() {
        parent.detailedSong = nil
    }
    
}
