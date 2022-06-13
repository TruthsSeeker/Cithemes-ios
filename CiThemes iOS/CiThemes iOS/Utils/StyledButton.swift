//
//  StyledButton.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/06/2022.
//

import SwiftUI

struct StyledButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.attentionGrabbing)
                    .frame(width: 160, height: 48, alignment: .center)
                Text(title)
                    .foregroundColor(.fontMain)
            }
        }
    }
}

struct StyledButton_Previews: PreviewProvider {
    static var previews: some View {
        StyledButton(title: "Hello", action: {})
    }
}
