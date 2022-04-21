//
//  NormalCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 08/04/2022.
//

import SwiftUI

struct NormalCell: View {
    var rank: Int
    var entry: PlaylistEntry
    @State var detailVM: SongDetailViewModel = SongDetailViewModel()
    
    @EnvironmentObject var context: PlaylistViewModel
    
    init(entry: PlaylistEntry, rank: Int) {
        self.rank = rank
        self.entry = entry
    }

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
                    Text(detailVM.details.title ?? "Unknown Title")
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontMain)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text(detailVM.details.artist ?? "Unknown Artist")
                        .font(Font.customFont(.openSans, size: 10))
                        .foregroundColor(Color.fontSecondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Text(String(entry.votes.formatForDisplay()))
                    .font(Font.customFont(.ralewayRegular, size: 17))
                    .foregroundColor(Color.relief)
                
                Button {
                    detailVM.vote()
                    context.update(id: entry.id, vote: .Up)
                } label: {
                    Image("Thumb Up")
                        .tint(.attentionGrabbing)
                }

            }
            .padding(16)
            
        }
        .background(.clear)
        .onAppear {
            detailVM.details = entry.songInfo
            detailVM.cityID = entry.cityId
        }
    }
}

struct NormalCell_Previews: PreviewProvider {
    static var previews: some View {
        NormalCell(entry: PlaylistEntry(id: 1, songInfo: SongInfo.example, votes: 345, cityId: 1), rank: 10)
    }
}

