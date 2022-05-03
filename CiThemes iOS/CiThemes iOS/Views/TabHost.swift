//
//  TabHost.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 02/05/2022.
//

import SwiftUI

struct TabHost: View {
    @State var selection: Int = 0
    var body: some View {
            TabBar()
            .background(Color.clear)
            .ignoresSafeArea()
        
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
        let playlist = UIHostingController(rootView: CityPlaylist())
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
        TabHost()
    }
}
