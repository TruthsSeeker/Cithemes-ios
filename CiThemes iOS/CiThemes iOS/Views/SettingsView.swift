//
//  SettingsView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 04/05/2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
            NavigationView {
                ZStack {
                    Color.background
                        .ignoresSafeArea()
                    List {
                        NavigationLink {
                            Button {
                                KeychainHelper.standard.logout()
                            } label: {
                                Text("Logout")
                            }

                        } label: {
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundColor(.fontAlwaysLight)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, -4)
                                Text("Account")
                                    .foregroundColor(.fontAlwaysLight)
                                    .padding(.leading, 8)
                            }
                        }
                        .listRowBackground(Color.accent)
                        
                    }
                    .padding(.top, 16)
                .navigationTitle(Text("Settings"))
                }
                
            }
            .background(.background)
            .onAppear {
                UINavigationBar.appearance().tintColor = UIColor.relief
                UINavigationBar.appearance().isTranslucent = true
                UINavigationBar.appearance().backgroundColor = .background
        }
    
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
