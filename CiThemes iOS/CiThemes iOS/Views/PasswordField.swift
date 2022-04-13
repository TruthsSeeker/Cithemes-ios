//
//  PasswordField.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    let placeholder: String
    var body: some View {
        ZStack {
            Rectangle()
               .foregroundColor(Color.accent)
               .cornerRadius(8)
               .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.relief, lineWidth: 1))
            VStack{
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text(placeholder)
                            .font(Font.customFont(.openSans, size: 14))
                            .foregroundColor(Color.relief.opacity(0.9))
                    }
                    SecureField("", text: $password)
                        .foregroundColor(.fontMain)
                }
                Rectangle()
                    .foregroundColor(Color.relief)
                    .frame(height: 2)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .frame(height: 40, alignment: .center)
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(password: .constant(""), placeholder: "Password")
    }
}
