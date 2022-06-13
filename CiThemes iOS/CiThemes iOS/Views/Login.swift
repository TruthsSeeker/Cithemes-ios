//
//  Login.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct Login: View {
    enum Field: Hashable {
        case email
        case password
    }
    
    @EnvironmentObject var userVM: UserViewModel
    @State var emailValid: Bool = true
    
    
    @FocusState private var focusedField: Field?
    
    let signUpAction: ()->()
    
    var body: some View {
        VStack {
            UsernameField(username: $userVM.email, valid: $emailValid)
                .padding([.trailing, .leading], 42)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                .focused($focusedField, equals: .email)
                
            Spacer()
                .frame(height: 48)
            
            PasswordField(password: $userVM.password, valid: .constant(true), placeholder: "Password")
                .padding([.trailing, .leading], 42)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
            
            Spacer()
                .frame(height: 90)
            
            Button {
                focusedField = nil
                emailValid = Validator.standard.validate(userVM.email, regex: Validator.emailRegex)
                if emailValid {
                    userVM.login()
                }
                
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
                focusedField = nil
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
        Group {
            Login(signUpAction: {})
                .environmentObject(UserViewModel(coordinator: TabCoordinator()))
        }
    }
}
