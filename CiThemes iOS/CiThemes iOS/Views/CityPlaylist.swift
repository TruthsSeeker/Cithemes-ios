//
//  CityPlaylist.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct CityPlaylist: View {
    @StateObject var playlistVM: PlaylistViewModel
    
    @State var searchShown: Bool = false
    @State var detailedSong: SongInfo?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.background
                
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        RemoteImage(playlistVM.city?.image, placeholder: Image("LosAngeles"))
                            .frame(height: 200)

                        ZStack {
                            Text(playlistVM.city?.name ?? "")
                                .font(.customFont(.ralewayRegular, size: 35))
                                .foregroundColor(.black)
                                .blur(radius: 1)
                            Text(playlistVM.city?.name ?? "")
                                .font(.customFont(.ralewayRegular, size: 35))
                                .foregroundColor(.fontAlwaysLight)
                        }
                        .padding(8)
                    }
                    .frame(height: 200, alignment: .top)
                    ZStack {
                        Color.background
                        RefreshableScrollView(onRefresh: { done in
                            playlistVM.fetch {
                                done()
                            }
                        }) {
                            LazyVStack {
                                ForEach(Array(playlistVM.songsDict.enumerated()), id: \.1) { index, entry in
                                    PlaylistCell(song: entry , rank: index)
                                        .onTapGesture {
                                            withAnimation(Animation.easeIn(duration: 0.2)) {
                                                detailedSong = entry.songInfo
                                            }
                                        }
                                        .transition(.opacity)
                                }
                            }
                        }
                        .environmentObject(playlistVM)
                        .refreshable {
                            playlistVM.fetch()
                        }
                    
                    }
                }
                .edgesIgnoringSafeArea([.top, .bottom])
                
                Button {
                    KeychainHelper.standard.delete(service: .userId)
                    KeychainHelper.standard.delete(service: .tokens)
                    KeychainHelper.standard.delete(service: .email)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                        Text("X")
                            .foregroundColor(.fontAlwaysLight)
                    }
                    .frame(width: 45, height: 45, alignment: .bottomLeading)
                }
                .position(x: 45, y: geo.size.height - 45)

                SearchButton(width: 45, height: 45) {
                    self.searchShown = true
                }
                .position(x: geo.size.width - 45, y: geo.size.height - 45)
                .sheet(isPresented: self.$searchShown) {
                    self.searchShown = false
                } content: {
                    SongSearch()
                }
                
                if let item = detailedSong {
                    SongDetails(details: item)
                        .edgesIgnoringSafeArea([.top,.bottom])
                        .onTapGesture {
                            withAnimation(Animation.easeIn(duration: 0.2)) {
                                detailedSong = nil
                            }
                        }
                        .transition(.opacity)
                        .environmentObject(playlistVM)
                }
            }
        }.onAppear {
            playlistVM.fetch()
        }
        .environmentObject(playlistVM)
    }
}

struct CityPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        CityPlaylist(playlistVM: PlaylistViewModel(list: [], city: City(country: "France", iso2: "FR", name: "Strasbourg", population: 123456)))
    }
}
