//
//  UsernameField.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

struct UsernameField: View {
    @Binding var username: String
    @Binding var valid: Bool
    var body: some View {
        ZStack {
            Rectangle()
               .foregroundColor(Color.accent)
               .cornerRadius(8)
               .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(valid ? Color.relief: Color.error, lineWidth: 1))
            VStack{
                ZStack(alignment: .leading) {
                    if username.isEmpty {
                        Text("E-mail")
                            .font(Font.customFont(.openSans, size: 14))
                            .foregroundColor(Color.relief.opacity(0.9))
                    }
                    TextField("", text: $username)
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontMain)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .tint(Color.relief)
                        
                }
                Rectangle()
                    .foregroundColor(valid ? Color.relief : Color.error)
                    .frame(height: 2)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .frame(height: 40, alignment: .center)
    }
}

struct UsernameField_Previews: PreviewProvider {
    static var previews: some View {
        UsernameField(username: .constant(""), valid: .constant(false))
    }
}
