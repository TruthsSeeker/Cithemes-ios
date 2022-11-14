//
//  PlaylistCellCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 02/09/2022.
//

import Foundation
import Combine

class PlaylistCellCoordinator: ObservableObject, UserViewCoordinator, SongDetailsCoordinator {
    private unowned let parent: RootCoordinator
    @Published var songVM: SongDetailViewModel?
    @Published var showDetails: Bool = false
    
    init(entry: PlaylistEntry, parent: RootCoordinator) {
        self.parent = parent
        self.songVM = SongDetailViewModel(entry: entry, coordinator: self)
    }
    func dismissDetails() {
        songVM = nil
    }
    
    func setDetail(for entry: PlaylistEntry) {
        songVM = SongDetailViewModel(entry: entry, coordinator: self)
    }
    
    
    func displayError(message: String) {
        parent.displayError(message: message)
    }
    
    func toggleLogin() {
        parent.toggleLogin()
    }
}
