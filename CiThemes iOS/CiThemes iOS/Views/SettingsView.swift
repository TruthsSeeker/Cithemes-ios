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
                        //MARK: Account page
                        NavigationLink() {
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
                        
                        //MARK: Hometown page
                        NavigationLink {
                            HometownSettingsView()
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
                        
                        //MARK: Contact page
                        NavigationLink {
                            AboutSettingsView()
                        } label: {
                            HStack {
                                Image(systemName: "info.bubble")
                                    .resizable()
                                    .foregroundColor(.fontMain)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, -4)
                                Text("About")
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
            .tint(.fontMain)
            .background(.background)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(RootCoordinator())
    }
}
