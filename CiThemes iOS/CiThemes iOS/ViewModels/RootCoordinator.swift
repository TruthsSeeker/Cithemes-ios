//
//  RootCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import Foundation
import Combine
import AlertToast

enum Tab {
    case home
    case search
    case setting
}

class RootCoordinator: ObservableObject, UserViewCoordinator {
    @Published var userViewModel: UserViewModel!
    @Published var hometownCoordinator: PlaylistCoordinator!
    @Published var hometownViewModel: PlaylistViewModel?
    @Published var tab = Tab.home
    @Published var showSignUp: Bool = false
    @Published var hometownId: Int?
    @Published var showError: Bool = false
    @Published var detailedSong: PlaylistEntry?
    
    var errorConfig: ErrorConfig?
    struct ErrorConfig {
        var message: String
        var type: AlertToast.AlertType = .error(.error)
    }
    
    init() {
        self.userViewModel = UserViewModel(coordinator: self)
        self.hometownCoordinator = PlaylistCoordinator(parent: self, city: nil)
    }
    
    func toggleLogin() {
        showSignUp.toggle()
    }
    
    func updateHometown(id: Int?) {
        self.hometownId = id
    }
    
    func displayError(message: String) {
        errorConfig = ErrorConfig(message: message)
        showError = true
    }
    
    func displayToast(message: String, type : AlertToast.AlertType) {
        errorConfig = ErrorConfig(message: message, type: type)
        showError = true
    }
}
