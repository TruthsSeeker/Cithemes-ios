//
//  SongDetailCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 05/09/2022.
//

import Foundation

class SongDetailCoordinator: ObservableObject, UserViewCoordinator {
    
    private unowned let parent: SongDetailsCoordinator
    @Published var songVM: SongDetailViewModel?
    
    init(entry: PlaylistEntry, parent: SongDetailsCoordinator){
        self.parent = parent
        self.songVM = SongDetailViewModel(entry: entry, coordinator: parent)
    }
    
    func toggleLogin() {
        parent.toggleLogin()
    }
    
    func displayError(message: String) {
        parent.displayError(message: message)
    }
}
