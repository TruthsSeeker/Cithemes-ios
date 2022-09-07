//
//  SettingsView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 04/05/2022.
//

import SwiftUI
import CoreLocation
import Introspect

struct SettingsView: View {
    @EnvironmentObject var coordinator: RootCoordinator
    @State var showAccountView: Bool = false
    @State private var nav: UINavigationController?
    
    var body: some View {
            NavigationView {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    List {
                        NavigationLink(isActive: $showAccountView) {
                            AccountView()
                        } label: {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .foregroundColor(.fontMain)
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, -4)
                                    Text("Account")
                                        .foregroundColor(.fontMain)
                                        .padding(.leading, 8)
                                }
                        }
                        .listRowBackground(Color.background)
                        
                        NavigationLink {
                            Text("Homepage")
                        } label: {
                            HStack {
                                Image(systemName: "building.2.crop.circle")
                                    .resizable()
                                    .foregroundColor(.fontMain)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, -4)
                                Text("Hometown")
                                    .foregroundColor(.fontMain)
                                    .padding(.leading, 8)
                                
                            }
                        }
                        .listRowBackground(Color.background)
                    }
                    .padding(.top, 16)
                .navigationTitle(Text("Settings"))
                }
                
            }
            .background(.background)
            .introspectNavigationController(customize: { nav in
                self.nav = nav
                self.setNavigationBarAppearance()
                
            })
    }
    
    private func setNavigationBarAppearance() {
        guard let nav = self.nav, coordinator.tab == .setting else { return }
        nav.navigationBar.tintColor = UIColor.relief
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.backgroundColor = .clear
        
        UITableView.appearance().backgroundColor = .clear
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
