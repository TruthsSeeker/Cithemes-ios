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
    @ObservedObject var detailVM: SongDetailViewModel
//    @State var showLogin: Bool = false
    
    @EnvironmentObject var context: PlaylistViewModel
    
    init(position: Rank, viewModel: SongDetailViewModel) {
        self.position = position
        self.detailVM = viewModel
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
                    Text(detailVM.details.title ?? "Unknown Title")
                        .font(Font.customFont(.openSans, size: 16))
                        .foregroundColor(Color.fontMain)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text(detailVM.details.artist ?? "Unknown Artist")
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontSecondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Text(String(detailVM.votes.formatForDisplay()))
                    .font(Font.customFont(.ralewayRegular, size: 17))
                    .foregroundColor(Color.relief)
                
                Button {
                    detailVM.vote {
//                        showLogin.toggle()
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
//        .sheet(isPresented: $showLogin, content: {
//            LoginSignUp()
//        })
//        .onAppear {
//            detailVM.details = entry.songInfo
//            detailVM.cityID = entry.cityId
//            detailVM.voted = entry.voted
//        }
    }
}

struct PodiumCell_Previews: PreviewProvider {
    static var previews: some View {
        PodiumCell(position: .second, viewModel: SongDetailViewModel(entry: PlaylistEntry(id: 1, songInfo: SongInfo.example, votes: 345, cityId: 1), coordinator: PlaylistCellCoordinator(entry: PlaylistEntry(id: 1, songInfo: SongInfo.example, votes: 345, cityId: 1), parent: RootCoordinator())))
    }
}
