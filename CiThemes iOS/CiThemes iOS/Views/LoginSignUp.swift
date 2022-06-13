//
//  LoginSignUp.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct LoginSignUp: View {
    //TODO LoginSignupCoordinator
    @State var loginIsShown: Bool = true
    
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
                    .frame(height: 96)
                FlippableView(isFaceUp: $loginIsShown) {
                    Login() {
                        loginIsShown.toggle()
                    }

                } backView: {
                    SignUp() {
                        loginIsShown.toggle()
                    }

                }

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
