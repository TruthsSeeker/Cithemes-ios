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
    var entry: PlaylistEntry
    @StateObject var detailVM: SongDetailViewModel = SongDetailViewModel()
    @State var showLogin: Bool = false
    
    @EnvironmentObject var context: PlaylistViewModel
    
    init(position: Rank, entry: PlaylistEntry) {
        self.position = position
        self.entry = entry
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.background)
                .frame(height: 48, alignment: .center)
            
            HStack {
                Text(String(position.rawValue))
                    .frame(width: 50, height: 50, alignment: .center)
                    .font(Font.customFont(.ralewayRegular, size: 24).weight(.semibold))
                    .foregroundColor(position == .second ? .silver : .bronze)
                
                VStack(alignment: .leading) {
                    Text(entry.songInfo.title ?? "Unknown Title")
                        .font(Font.customFont(.openSans, size: 16))
                        .foregroundColor(Color.fontMain)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text(entry.songInfo.artist ?? "Unknown Artist")
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontSecondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Text(String(entry.votes.formatForDisplay()))
                    .font(Font.customFont(.ralewayRegular, size: 17))
                    .foregroundColor(Color.relief)
                
                Button {
                    detailVM.vote {
                        showLogin.toggle()
                    } onSuccess: {
                        context.fetch()
                    }
                } label: {
                    Image(detailVM.voted ? "Thumb Up Filled" : "Thumb Up")
                        .tint(.attentionGrabbing)
                }
            }
            .padding(16)
            
        }
        .background(.clear)
        .sheet(isPresented: $showLogin, content: {
            LoginSignUp()
        })
        .onAppear {
            detailVM.details = entry.songInfo
            detailVM.cityID = entry.cityId
            detailVM.voted = entry.voted
        }
    }
}

struct PodiumCell_Previews: PreviewProvider {
    static var previews: some View {
        PodiumCell(position: .second, entry: PlaylistEntry(id: "1", songInfo: SongInfo.example, votes: 234, cityId: 1))
    }
}
