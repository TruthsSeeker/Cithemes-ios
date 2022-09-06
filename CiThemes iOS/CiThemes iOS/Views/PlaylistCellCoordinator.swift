//
//  PlaylistCellCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 02/09/2022.
//

import Foundation
import Combine

class PlaylistCellCoordinator: ObservableObject, UserViewCoordinator {
    private unowned let parent: RootCoordinator
    @Published var song: SongDetailViewModel?
    @Published var showDetails: Bool = false
    
    init(entry: PlaylistEntry, parent: RootCoordinator) {
        self.parent = parent
        self.song = SongDetailViewModel(entry: entry, coordinator: self)
    }
    
    func toggleDetails() {
        showDetails.toggle()
    }
    
    func displayError(message: String) {
        parent.displayError(message: message)
    }
    
    func toggleLogin() {
        parent.toggleLogin()
    }
}
