//
//  NormalCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 08/04/2022.
//

import SwiftUI

struct NormalCell: View {
    var song: PlaylistEntry
    var vote: ()->()

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.background)
                .frame(height: 40, alignment: .center)
            
            HStack {
                Text("2")
                    .frame(width: 50, height: 40, alignment: .center)
                    .font(Font.customFont(.ralewayRegular, size: 24).weight(.semibold))
                    .foregroundColor(Color.accent)
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontMain)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text("Artist")
                        .font(Font.customFont(.openSans, size: 10))
                        .foregroundColor(Color.fontSecondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Text("Score")
                    .font(Font.customFont(.ralewayRegular, size: 17))
                    .foregroundColor(Color.relief)
            }
            .padding(16)
            
        }
        .background(.clear)
    }
}

struct NormalCell_Previews: PreviewProvider {
    static var previews: some View {
        NormalCell()
    }
}

