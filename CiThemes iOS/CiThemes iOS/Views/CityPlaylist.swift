//
//  CityPlaylist.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct CityPlaylist: View {
    @StateObject var playlistVM: SongListViewModel = SongListViewModel(list: [], cityId: 1)
    
    @State var searchShown: Bool = false
    @State var detailedSong: SongInfo?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.background
                
                VStack {
                    Image("LosAngeles", bundle: nil)
                        .resizable()
                        .frame(height: 204, alignment: .top)
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
                            print("Refresh")
                            playlistVM.fetch()
                        }
                    
                    }
                }
                .edgesIgnoringSafeArea([.top, .bottom])
                
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
                }

            }
            .environmentObject(playlistVM)
        }.onAppear {
            playlistVM.fetch()
        }
    }
}

struct CityPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        CityPlaylist()
    }
}
