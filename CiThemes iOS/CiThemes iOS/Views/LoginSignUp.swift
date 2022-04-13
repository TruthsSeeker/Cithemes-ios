//
//  LoginSignUp.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct LoginSignUp: View {
    @State var loginIsShown: Bool = true
    @StateObject var userVM: UserViewModel = UserViewModel()
    
    var body: some View {
        ZStack{
            Color.background
            VStack {
                Spacer()
                    .frame(height: 120)
                Text("CiThemes")
                    .font(Font.customFont(.ralewayDots, size: 72).bold())
                    .foregroundColor(.attentionGrabbing)
                Spacer()
                    .frame(height: 40)
                FlippableView(isFaceUp: $loginIsShown, frontView: Login(email: $userVM.email, password: $userVM.password, action: {
                    userVM.login()
                }, signUpAction: {
                    loginIsShown.toggle()
                }), backView: SignUp(email: $userVM.email, password: $userVM.password, action: {
                    userVM.signup()
                }, loginAction: {
                    loginIsShown.toggle()
            }))
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
