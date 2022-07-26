//
//  SignUp.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct SignUp: View {
    enum Field: Hashable {
        case email
        case password
        case confirm
    }
    
    @EnvironmentObject var coordinator: TabCoordinator
    
    @State var emailValid: Bool = true
    @State var passwordValid: Bool = true
    @State var confirmPassword: String = ""
    @State var confirmValid: Bool = true
    @FocusState var focus: Field?
    
    let loginAction: ()->()
    var body: some View {
        VStack {
            UsernameField(username: $coordinator.userViewModel.email, valid: $emailValid)
                .padding([.trailing, .leading], 42)
                .focused($focus, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focus = .password
                }
            
            Spacer()
                .frame(height: 48)
            
            PasswordField(password: $coordinator.userViewModel.password, valid: $passwordValid, placeholder: "Password")
                .padding([.trailing, .leading], 42)
                .focused($focus, equals: .password)
                .submitLabel(.next)
                .onSubmit {
                    focus = .confirm
                }
            
            Spacer()
                .frame(height: 36)
            
            PasswordField(password: $confirmPassword, valid: $passwordValid, placeholder: "Confirm Password")
                .padding([.trailing, .leading], 42)
                .focused($focus, equals: .confirm)
                .submitLabel(.done)
            
            Spacer()
                .frame(height: 48)
            
            Button {
                focus = nil
                emailValid = Validator.standard.validate(coordinator.userViewModel.email, regex: Validator.emailRegex)
                passwordValid = Validator.standard.validate(coordinator.userViewModel.password, regex: Validator.passwordRegex)
                confirmValid = coordinator.userViewModel.password == confirmPassword
                if emailValid && passwordValid && confirmValid {
                    coordinator.userViewModel.signup()
                }
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
                focus = nil
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
        SignUp(loginAction: {})
            .environmentObject(UserViewModel(coordinator: TabCoordinator()))
    }
}
