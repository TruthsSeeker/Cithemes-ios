//
//  SongDetailsCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 06/09/2022.
//

import Foundation

protocol SongDetailsCoordinator: UserViewCoordinator {
    func dismissDetails()
    
    func setDetail(for entry: PlaylistEntry)
}
