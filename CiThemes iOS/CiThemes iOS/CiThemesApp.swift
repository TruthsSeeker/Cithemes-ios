//
//  App.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

@main
struct CiThemesApp: App {
    var body: some Scene {
        WindowGroup {
            LocationButton { location in
                print(location)
            }
        }
    }
}
