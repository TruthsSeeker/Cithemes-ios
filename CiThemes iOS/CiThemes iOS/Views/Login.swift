//
//  Login.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct Login: View {
    @Binding var email: String
    @Binding var password: String
    let action: ()->()
    let signUpAction: ()->()
    var body: some View {
        VStack {
            Spacer()
            UsernameField(username: $email)
                .padding([.trailing, .leading], 42)
                
            Spacer()
                .frame(height: 48)
            PasswordField(password: $password, placeholder: "Password")
                .padding([.trailing, .leading], 42)
            Spacer()
                .frame(height: 74)
            Button {
                print("email:\(email),\(password)")
                action()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.attentionGrabbing)
                        .frame(width: 160, height: 48, alignment: .center)
                    Text("Login")
                        .foregroundColor(.fontMain)
                }
            }
            
            Button {
                signUpAction()
            } label: {
                Text("Don't have an account?\n Sign up")
                    .underline()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.fontSecondary)
            }
            Spacer()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(email: .constant(""), password: .constant(""), action: {}, signUpAction: {})
    }
}
