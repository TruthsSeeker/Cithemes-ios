//
//  SongDetails.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 11/03/2022.
//

import SwiftUI

struct SongDetails: View {
    @ObservedObject var songVM: SongDetailViewModel
    @EnvironmentObject var playlistContext: PlaylistViewModel

    var body: some View {
        ZStack {
            Color.dimming
                .onTapGesture {
                    withAnimation(Animation.easeIn(duration: 0.2)) {
                        songVM.dismiss()
                    }
                }
                .transition(.opacity)
            GeometryReader { geo in
                VStack {
                    HStack(alignment: .top, spacing: 8) {
                        RemoteImage(songVM.details.cover, placeholder: Image("rhcp", bundle: nil))
                            .frame(width: 90, height: 90, alignment: .center)
                            .cornerRadius(8)
                            .clipped()
                        VStack(alignment: .leading, spacing: 2){
                            Text(songVM.details.title ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(Font.customFont(.ralewayRegular, size: 18))
                                .foregroundColor(Color.fontMain)
                            HStack{
                                Text("Artist:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(songVM.details.artist ?? "")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Text("Album:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(songVM.details.album ?? "")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)

                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Text("Released:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(songVM.details.release ?? "")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)

                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Text("Duration:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(TimeInterval(songVM.details.duration ?? 0).minuteSecond)
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)

                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }
                        .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90, alignment: .top)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let url = songVM.details.preview {
                        PreviewPlayer(player: PreviewPlayerViewModel(url: url))
                    }

                    DetailsVote(votes: songVM.votes, voted: songVM.voted) {
                        songVM.vote()
                    }
                }
                .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8))
                .frame(width: geo.size.width * 0.9)
                .background(Color.accent)
                .cornerRadius(12)
                .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.bottom] })
                .position(x: geo.size.width / 2, y: geo.size.height / 2)

            }
        }
    }
}

struct SongDetails_Previews: PreviewProvider {
    static var entry = PlaylistEntry(id: -1, songInfo: SongInfo.example, cityId: -1)
    static var previews: some View {
        SongDetails(
            songVM: SongDetailViewModel(
                entry: entry,
                coordinator: PlaylistCoordinator(parent: RootCoordinator(), city: City.placeholder))
            )
        .environmentObject(PlaylistViewModel(coordinator: PlaylistCoordinator(parent: RootCoordinator(), city: City.placeholder)))
            .environmentObject(RootCoordinator())
            
    }
}
