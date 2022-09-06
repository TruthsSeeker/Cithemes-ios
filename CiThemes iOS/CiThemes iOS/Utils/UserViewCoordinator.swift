//
//  UserViewCoordinator.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import Foundation

protocol UserViewCoordinator: AnyObject {
    func toggleLogin()
    func displayError(message: String)
}
