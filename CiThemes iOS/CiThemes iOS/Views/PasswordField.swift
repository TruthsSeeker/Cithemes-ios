//
//  PasswordField.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    @Binding var valid: Bool
    let placeholder: String
    var body: some View {
        ZStack {
            Rectangle()
               .foregroundColor(Color.accent)
               .cornerRadius(8)
               .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(valid ? Color.relief: Color.error, lineWidth: 1))
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
                    .foregroundColor(valid ? Color.relief: Color.error)
                    .frame(height: 2)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .frame(height: 40, alignment: .center)
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(password: .constant(""), valid: .constant(true), placeholder: "Password")
    }
}
