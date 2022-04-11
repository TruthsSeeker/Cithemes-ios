//
//  NormalCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 08/04/2022.
//

import SwiftUI

struct NormalCell: View {
    var entry: PlaylistEntry
    var rank: Int
    
    @EnvironmentObject var context: SongListViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.background)
                .frame(height: 40, alignment: .center)
            
            HStack {
                Text(String(rank))
                    .frame(width: 50, height: 40, alignment: .center)
                    .font(Font.customFont(.ralewayRegular, size: 24).weight(.semibold))
                    .foregroundColor(Color.accent)
                
                VStack(alignment: .leading) {
                    Text(entry.songInfo?.title ?? "Unknown Title")
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontMain)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text(entry.songInfo?.artist ?? "Unknown Artist")
                        .font(Font.customFont(.openSans, size: 10))
                        .foregroundColor(Color.fontSecondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Text(String(entry.votes))
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
        NormalCell(entry: PlaylistEntry(id: 1, songInfo: SongInfo.example, votes: 345, cityId: 1), rank: 10)
    }
}

