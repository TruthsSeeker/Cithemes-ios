//
//  App.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

@main
struct CiThemesApp: App {
    @Environment(\.colorScheme) var scheme
    var body: some Scene {
        WindowGroup {
            TabNavigationView()
                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
//        //                UIApplication.shared.setAlternateIconName(scheme == .dark ? "AppIcon Dark" : nil)
//                        UIApplication.shared.setAlternateIconName(currentSystemScheme == .dark ? "Dark" : nil) { error in
//                            if let error {
//                                print(error)
//                            }
//                        }
//                    }
            }
                
        }
    }
}

