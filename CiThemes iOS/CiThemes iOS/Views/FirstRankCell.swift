//
//  FirstRankCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct FirstRankCell: View {
    var song: PlaylistEntry
    var vote: ()->()

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.accent)
                .frame(height: 80, alignment: .center)
                .border(Color.relief)
                .cornerRadius(6)
            HStack {
                ZStack {
                    Image("Star 1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .center)
                        .foregroundColor(.attentionGrabbing)
                    Text("1")
                        .frame(width: 50, height: 50, alignment: .center)
                        .font(Font.customFont(.ralewayRegular, size: 42))
                        .foregroundColor(Color.fontMain)
                }
                .padding(8)
                
                VStack(alignment: .leading, spacing:16) {
                    Text("Title")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.openSans, size: 16))
                        .foregroundColor(Color.fontMain)
                    Text("Artist")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.ralewayRegular, size: 14))
                        .foregroundColor(Color.fontSecondary)
                }
                .padding([.trailing], 8)
                
                Text("Score")
                    .padding([.trailing], 8)
            }
        }
        .padding(8)
        .background(.clear)
    }
}

struct FirstRankCell_Previews: PreviewProvider {
    static var previews: some View {
        FirstRankCell(song: PlaylistEntry(id: 0), vote: {})
    }
}
