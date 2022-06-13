//
//  TabHost.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 02/05/2022.
//

import SwiftUI

struct TabNavigationView: View {
    @ObservedObject var coordinator: TabCoordinator = TabCoordinator()
    
    init() {
        configureApperance()
    }
    
    var body: some View {
        TabView(selection: $coordinator.tab) {
            HometownView()
                .tabItem {
                    Image("Home Tab")
                    Text("Hometown")
                }
                .tag(Tab.home)
            CitySearch()
                .tabItem {
                    Image("magnifying-glass")
                    Text("Search")
                }
                .tag(Tab.search)
        }
        .transition(.slide)
        .animation(.easeInOut, value: coordinator.tab)
        .onAppear {
            UITabBar.appearance().backgroundColor = .accent
            UITabBar.appearance().barTintColor = .relief
            
        }
        .tint(.tabSelected)
        .accentColor(.tabSelected)
        .sheet(isPresented: $coordinator.showSignUp) {
            LoginSignUp()
                .environmentObject(coordinator.userViewModel)
        }
        .environmentObject(coordinator)
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
        appearance.stackedLayoutAppearance = tabitemAppearance
        UITabBar.appearance().standardAppearance = appearance
    }
}

struct TabBar: UIViewControllerRepresentable {
    class Coordinator: NSObject, UITabBarControllerDelegate {
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> TabBarController {
        let controller = TabBarController()
        controller.delegate = context.coordinator
        let playlist = UIHostingController(rootView: CityPlaylist(playlistVM: PlaylistViewModel(list: [])))
        playlist.tabBarItem = UITabBarItem(title: "Hometown", image: UIImage(named: "Home Tab"), tag: 0)
        controller.viewControllers = [playlist]
        
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

struct TabHost_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
