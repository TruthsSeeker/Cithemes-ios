//
//  HometownCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 23/08/2022.
//

import Foundation

class HometownCoordinator: ObservableObject {
    @Published var hometownId: Int?
    
    init(id: Int?) {
        self.hometownId = id
    }
    
    func setHometown(id: Int?) {
        self.hometownId = id
    }
}
