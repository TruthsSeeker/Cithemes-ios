//
//  SearchButton.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/01/2022.
//

import SwiftUI

struct SearchButton: View {
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    init(width: CGFloat, height: CGFloat, action: @escaping () -> Void) {
        self.width = width
        self.height = height
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image("magnifying-glass", bundle: nil)
                .resizable()
                .foregroundColor(Color("FontMain", bundle: nil))
                .frame(width: width*0.7, height: width*0.7, alignment: .center)
                .scaledToFit()
        }
        .padding()
        .background(Color("Relief", bundle: nil))
        .frame(width: width, height: height, alignment: .center)
        .cornerRadius(width)
        .shadow(color: .gray, radius: 2, x: 2, y: 2)
        
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton(width: 45, height: 45, action: {print("Preview")})
    }
}
