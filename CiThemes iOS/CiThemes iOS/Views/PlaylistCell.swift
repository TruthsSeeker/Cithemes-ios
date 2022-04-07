//
//  PlaylistCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct PlaylistCell: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.background)
                .frame(height: 40, alignment: .center)
            
            HStack {
                Text("2")
                    .frame(width: 40, height: 40, alignment: .center)
                    .font(Font.customFont(.ralewayRegular, size: 24).weight(.semibold))
                    .foregroundColor(Color.accent)
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(Font.customFont(.openSans, size: 16))
                        .foregroundColor(Color.fontMain)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text("Artist")
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontSecondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Text("Score")
                    .font(Font.customFont(.ralewayRegular, size: 17))
                    .foregroundColor(Color.relief)
            }
            .padding(8)
            
        }
        .background(.clear)
    }
}

struct PlaylistCell_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistCell()
    }
}
