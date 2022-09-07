//
//  TabHost.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 02/05/2022.
//

import SwiftUI
import AlertToast

struct TabNavigationView: View {
    @ObservedObject var coordinator: RootCoordinator = RootCoordinator()
    
    init() {
        configureApperance()
    }
    
    var body: some View {
        TabView(selection: $coordinator.tab) {
            HometownCoordinatorView(hometownId: coordinator.hometownId)
                .tabItem {
                    Image("Home Tab")
                    Text("Hometown")
                }
                .tag(Tab.home)
                .environmentObject(coordinator.hometownCoordinator)
            CitySearch()
                .tabItem {
                    Image("magnifying-glass")
                    Text("Search")
                }
                .tag(Tab.search)
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(Tab.setting)
                .tint(.tabSelected)
        }
        .transition(.slide)
        .animation(.easeInOut, value: coordinator.tab)
        .onAppear {
            UITabBar.appearance().backgroundColor = .accent
            UITabBar.appearance().barTintColor = .relief
            
        }
        .sheet(isPresented: $coordinator.showSignUp) {
            LoginSignUp()
                .environmentObject(coordinator)
        }
        .environmentObject(coordinator)
        .toast(isPresenting: $coordinator.showError, duration: 2, tapToDismiss: false) {
            AlertToast(
                displayMode: .alert,
                type: coordinator.errorConfig?.type ?? .regular,
                title: coordinator.errorConfig?.message,
                style: .some(.style(
                        backgroundColor: Color.relief,
                        titleColor: Color.error,
                        titleFont: .customFont(.openSans, size: 18))
                )
            )
        } completion: {
            coordinator.showError = false
        }

    }
    
    fileprivate func configureApperance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .accent
        
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 8),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.1).cgColor
            ])
        let tabitemAppearance = UITabBarItemAppearance()
        tabitemAppearance.normal.iconColor = .relief
        tabitemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.relief as Any]
        tabitemAppearance.selected.iconColor = .tabSelected
        tabitemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.tabSelected as Any]
        appearance.stackedLayoutAppearance = tabitemAppearance
        UITabBar.appearance().standardAppearance = appearance
    }
}

struct TabHost_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
