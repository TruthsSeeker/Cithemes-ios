//
//  AccountView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 03/06/2022.
//

import SwiftUI
import Introspect

struct AccountView: View {
    @EnvironmentObject var coordinator: TabCoordinator
    @State var editable: Bool = false
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var newPassword: String = ""
    @State var confirmNewPassword: String = ""
    @State var list: UITableView?
    var body: some View {
        ZStack {
            if coordinator.userViewModel.user != nil {
                List {
                    TextField("Username", text: $username)
                        .disabled(!editable)
                        .tint(.red)
                    TextField("Email", text: $email)
                        .disabled(!editable)
                    
                    NavigationLink("Change your password") {
                        //TODO: Change password view
                        Text("Change Password Placeholder")
                    }
                    .foregroundColor(.fontMain)
                    Button {
                        coordinator.userViewModel.logout()
                    } label: {
                        Text("Logout")
                            .foregroundColor(.fontMain)
                    }
                
                }
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
            .environmentObject(TabCoordinator())
    }
}
