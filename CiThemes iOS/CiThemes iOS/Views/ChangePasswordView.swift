//
//  ChangePasswordView.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 20/10/2022.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var coordinator: RootCoordinator
    @State var password: String = ""
    @State var newPassword: String = ""
    @State var confirmNewPassword: String = ""
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Previous password", text: $password)
                        .frame(height: 60)
                    
                    TextField("New password", text: $newPassword)
                        .frame(height: 60)
                    
                    TextField("Confirm new password", text: $confirmNewPassword)
                        .frame(height: 60)
                }
                StyledButton(title: "Confirm") {
                    if newPassword == confirmNewPassword  {
                        coordinator.userViewModel.updatePassword(password, newPassword: newPassword) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                Spacer()
            }
            .padding(12)
            .padding(.top, 32)
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
