//
//  TabBarController.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 03/05/2022.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .attentionGrabbing
        self.tabBar.unselectedItemTintColor = .relief
        UITabBar.appearance().backgroundColor = .accent
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.tabBar.layer.shadowColor = Color.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.5
    }
}

