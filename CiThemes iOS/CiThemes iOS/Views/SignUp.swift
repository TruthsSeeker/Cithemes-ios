//
//  SignUp.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct SignUp: View {
    @Binding var email: String
    @Binding var password: String
    @State var confirmPassword: String = ""
    let action: ()->()
    let loginAction: ()->()
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
                .frame(height: 36)
            PasswordField(password: $confirmPassword, placeholder: "Confirm Password")
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
                    Text("Sign Up")
                        .foregroundColor(.fontMain)
                }
            }
            Button {
                loginAction()
                
            } label: {
                Text("Already have an account?\n Log in")
                    .underline()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.fontSecondary)
            }
            Spacer()
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(email: .constant(""), password: .constant(""), action: {}, loginAction: {})
    }
}
