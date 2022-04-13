//
//  LoginSignUp.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct LoginSignUp: View {
    @State var showSignUp: Bool = false
    @StateObject var userVM: UserViewModel = UserViewModel()
    
    var body: some View {
        ZStack{
            Color.background
            if showSignUp {
                ZStack{
                    SignUp(email: $userVM.email, password: $userVM.password) {
                        userVM.signup()
                    } loginAction: {
                        withAnimation(.linear(duration: 0.5)) {
                            showSignUp.toggle()
                        }
                    }
                }
                .transition(.flipShow)
            } else {
                ZStack{
                    Login(email: $userVM.email, password: $userVM.password) {
                        userVM.login()
                    } signUpAction: {
                        withAnimation(.linear(duration: 0.5)) {
                            showSignUp.toggle()
                        }
                    }
                    
                }
                .transition(.flipHide)
            }
        }
        .edgesIgnoringSafeArea([.top,.bottom])
    }
}

struct LoginSignUp_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUp()
    }
}
