//
//  SongDetails.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 11/03/2022.
//

import SwiftUI

struct SongDetails: View {
    @StateObject private var detailsViewModel: SongDetailViewModel = SongDetailViewModel()
    @EnvironmentObject var playlistContext: PlaylistViewModel
    @State var showLogin: Bool = false
    var details: SongInfo
    
    var body: some View {
        ZStack {
            Color.dimming
            GeometryReader { geo in
                VStack {
                    HStack(alignment: .top, spacing: 8) {
                        RemoteImage(detailsViewModel.details.cover, placeholder: Image("rhcp", bundle: nil))
                            .frame(width: 90, height: 90, alignment: .center)
                            .cornerRadius(8)
                            .clipped()
                        VStack(alignment: .leading, spacing: 2){
                            Text(detailsViewModel.details.title ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(Font.customFont(.ralewayRegular, size: 18))
                                .foregroundColor(Color.fontMain)
                            HStack{
                                Text("Artist:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(detailsViewModel.details.artist ?? "")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Text("Album:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(detailsViewModel.details.album ?? "")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)

                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Text("Released:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(detailsViewModel.details.release ?? "")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)

                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Text("Duration:")
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                Text(TimeInterval(detailsViewModel.details.duration ?? 0).minuteSecond)
                                    .font(Font.customFont(.openSans, size: 11))
                                    .foregroundColor(Color.fontSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)

                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }
                        .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90, alignment: .top)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Vote") {
                        guard KeychainHelper.standard.read(service: .tokens, account: KeychainHelper.account, type: UserToken.self) != nil else {
                            showLogin.toggle()
                            return
                        }
                        detailsViewModel.vote()
                        
                    }
                    .sheet(isPresented: $showLogin) {
                        LoginSignUp()
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
        .onAppear {
            detailsViewModel.details = details
            detailsViewModel.cityID = playlistContext.city?.id ?? 0
        }
    }
}

struct SongDetails_Previews: PreviewProvider {
    static var previews: some View {
        SongDetails(details: SongInfo.example).environmentObject(PlaylistViewModel(list: [], city: City(country: "France", iso2: "FR", name: "Strasbourg", population: 123456)))
    }
}
