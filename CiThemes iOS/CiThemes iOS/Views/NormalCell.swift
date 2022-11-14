//
//  NormalCell.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 08/04/2022.
//

import SwiftUI

struct NormalCell: View {
    var rank: Int
//    var entry: PlaylistEntry
    @ObservedObject var detailVM: SongDetailViewModel
    @State var showLogin: Bool = false
    
    @EnvironmentObject var context: PlaylistViewModel
    
    init(viewModel: SongDetailViewModel, rank: Int) {
        self.rank = rank
        self.detailVM = viewModel
        
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
                    .foregroundColor(Color.relief)
                
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
                Text(String(detailVM.votes.formatForDisplay()))
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
    }
}

struct NormalCell_Previews: PreviewProvider {
    static var previews: some View {
        NormalCell(viewModel: SongDetailViewModel(entry: PlaylistEntry(id: 1, songInfo: SongInfo.example, votes: 345, cityId: 1), coordinator: PlaylistCellCoordinator(entry: PlaylistEntry(id: 1, songInfo: SongInfo.example, votes: 345, cityId: 1), parent: RootCoordinator())),  rank: 10)
    }
}

