//
//  AccountView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 03/06/2022.
//

import SwiftUI
import Introspect

struct AccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var coordinator: RootCoordinator
    @State var editable: Bool = false
    @State var username: String = ""
    @State var email: String = ""

    @State var list: UITableView?
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            if coordinator.userViewModel.user != nil {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Email", text: $email)
                        .disabled(!editable)
                        .frame(height: 60)
                    
                    NavigationLink {
                        ChangePasswordView()
                    }
                    label: {
                        HStack {
                            Text("Change your password")
                                .foregroundColor(.fontMain)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.fontMain)
                        }
                    }
                    .frame(height: 40)
                    .foregroundColor(.fontMain)
                    Button {
                        coordinator.userViewModel.logout()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Logout")
                            .foregroundColor(Color.fontMain)
                    }
                    .frame(height: 40)
                    Spacer()
                }
                .padding(12)
                .padding(.top, 32)
            } else {
                VStack {
                    Text("You don't seem to be logged in")
                    Text("Do you want to log in or sign up?")
                    Button {
                        coordinator.toggleLogin()
                    } label: {
                        Text("Log in/Sign up")
                    }
                    
                }
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let user = coordinator.userViewModel.user {
                    self.username = user.username ?? ""
                    self.email = user.email
                }                
            }
        }
        .navigationTitle("Account")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if editable {
                    Button {
                        editable.toggle()
                    } label: {
                        Text("Cancel")
                    }
                .foregroundColor(.relief)
                } else {
                    EmptyView()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if editable {
                        //TODO: Send changes
                        coordinator.userViewModel.user?.email = email
                        coordinator.userViewModel.user?.username = username
                        coordinator.userViewModel.update()
                    }
                    editable.toggle()
                } label: {
                    if editable {
                        Text("Ok")
                    } else {
                        Image(systemName: "square.and.pencil")
                    }
                }
                .foregroundColor(.relief)

            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(RootCoordinator())
    }
}
