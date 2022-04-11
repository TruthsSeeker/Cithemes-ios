//
//  PodiumCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct PodiumCell: View {
    enum Rank: Int {
        case second = 2, third
    }
    
    var position: Rank
    var song: PlaylistEntry
    var vote: ()->()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.background)
                .frame(height: 48, alignment: .center)
            
            HStack {
                Text("2")
                    .frame(width: 50, height: 50, alignment: .center)
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
            .padding(16)
            
        }
        .background(.clear)
    }
}

struct PodiumCell_Previews: PreviewProvider {
    static var previews: some View {
        PodiumCell(songVM: SongDetailViewModel())
    }
}
