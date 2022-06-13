//
//  AccountView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 03/06/2022.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var editable: Bool = false
    var body: some View {
        List {
            Button {
                
                KeychainHelper.standard.logout()
            } label: {
                Text("Logout")
            }
        }
        .navigationTitle("Account")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editable.toggle()
                } label: {
                    Text("Cancel")
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

            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
