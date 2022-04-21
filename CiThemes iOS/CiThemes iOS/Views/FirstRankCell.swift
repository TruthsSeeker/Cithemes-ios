//
//  FirstRankCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct FirstRankCell: View {
    @EnvironmentObject var context: PlaylistViewModel

    var entry: PlaylistEntry
    @State var detailVM: SongDetailViewModel = SongDetailViewModel()
    
    init(entry: PlaylistEntry){
        self.entry = entry
        detailVM.details = entry.songInfo
        detailVM.cityID = entry.cityId
    }
    
    
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
                    Text(entry.songInfo.title ?? "Title")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.openSans, size: 16))
                        .foregroundColor(Color.fontMain)
                    Text(entry.songInfo.artist ?? "Artist")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.ralewayRegular, size: 14))
                        .foregroundColor(Color.fontSecondary)
                }
                .padding([.trailing], 8)
                
                Text(String(entry.votes))
                    .font(.customFont(.ralewayRegular, size: 18).bold())
                    .foregroundColor(.background)
                
                Button {
                    detailVM.vote()
                    context.update(id: entry.id, vote: .Up)
                } label: {
                    Image("Thumb Up")
                        .tint(.attentionGrabbing)
                }
                .padding([.trailing], 8)
            }
        }
        .padding(8)
        .background(.clear)
        .onAppear {
            detailVM.details = entry.songInfo
            detailVM.cityID = entry.cityId
        }

    }
}

struct FirstRankCell_Previews: PreviewProvider {
    static var previews: some View {
        FirstRankCell(entry: PlaylistEntry(id: 0, songInfo: SongInfo.example, votes: 500, cityId: 1))
    }
}
