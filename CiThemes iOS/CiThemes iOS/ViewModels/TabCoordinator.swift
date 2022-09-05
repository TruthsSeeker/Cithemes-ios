//
//  TabCoordinator.swift
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

class TabCoordinator: ObservableObject, UserViewCoordinator {
    @Published var userViewModel: UserViewModel!
    @Published var tab = Tab.home
    @Published var showSignUp: Bool = false
    @Published var hometownId: Int?
    @Published var showError: Bool = false
    
    var errorConfig: ErrorConfig?
    struct ErrorConfig {
        var message: String
        var type: AlertToast.AlertType = .error(.error)
    }
    
    init() {
        self.userViewModel = UserViewModel(coordinator: self)
        
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
