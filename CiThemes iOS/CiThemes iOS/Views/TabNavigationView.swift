//
//  TabHost.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 02/05/2022.
//

import SwiftUI

struct TabNavigationView: View {
    @State var selection: Int = 0
    
    init() {
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
        tabitemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.relief]
        appearance.stackedLayoutAppearance = tabitemAppearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CityPlaylist(playlistVM: PlaylistViewModel())
                .tabItem {
                    Image("Home Tab")
                    Text("Hometown")
                }
                .tag(0)
            CitySearch()
                .tabItem {
                    Image("magnifying-glass")
                    Text("Search")
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .accent
            UITabBar.appearance().barTintColor = .relief
            
        }
        .tint(.tabSelected)
        .accentColor(.tabSelected)
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
