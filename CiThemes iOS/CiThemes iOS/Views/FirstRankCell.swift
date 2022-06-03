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
    @StateObject var detailVM: SongDetailViewModel = SongDetailViewModel()
    @State var showLogin: Bool = false
    
    init(entry: PlaylistEntry){
        self.entry = entry
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
                    Text(detailVM.details.title ?? "Title")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.openSans, size: 16))
                        .foregroundColor(Color.fontMain)
                    Text(detailVM.details.artist ?? "Artist")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.ralewayRegular, size: 14))
                        .foregroundColor(Color.fontSecondary)
                }
                .padding([.trailing], 8)
                
                Text(String(entry.votes.formatForDisplay()))
                    .font(.customFont(.ralewayRegular, size: 18).bold())
                    .foregroundColor(.background)
                
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
                .padding([.trailing], 8)
            }
        }
        .padding(8)
        .background(.clear)
        .sheet(isPresented: $showLogin, content: {
            LoginSignUp {
                showLogin.toggle()
            }
        })
        .onAppear {
            detailVM.details = entry.songInfo
            detailVM.cityID = entry.cityId
            detailVM.voted = entry.voted
        }

    }
}

struct FirstRankCell_Previews: PreviewProvider {
    static var previews: some View {
        FirstRankCell(entry: PlaylistEntry(id: 0, songInfo: SongInfo.example, votes: 500, cityId: 1))
    }
}
