//
//  TabCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import Foundation
import Combine

enum Tab {
    case home
    case search
    case setting
}

class TabCoordinator: ObservableObject, UserViewCoordinator {
    @Published var tab = Tab.home
    @Published var userViewModel: UserViewModel!
    @Published var showSignUp: Bool = false
    @Published var hometownId: Int?
    
    init() {
        self.userViewModel = UserViewModel(coordinator: self)
        
    }
    
    func toggleLogin() {
        showSignUp.toggle()
    }
    
    func updateHometown(id: Int?) {
        self.hometownId = id
    }
}
