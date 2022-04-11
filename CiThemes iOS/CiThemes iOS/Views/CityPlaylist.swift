//
//  CityPlaylist.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct CityPlaylist: View {
    @StateObject var playlistVM: SongListViewModel = SongListViewModel.placeholder
    
    @State var searchShown: Bool = false
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
                        ScrollView {
                            LazyVStack {
                                ForEach(0..<playlistVM.songsDict.count) { index in
                                    PlaylistCell(style: PlaylistCell.CellStyle(rawValue: index), song: playlistVM.songsDict[index])
                                }
//                                ForEach(0 ..< playlistVM.songsDict.count) { index in
//                                    if index == 0 {
//                                        FirstRankCell(songVM: SongDetailViewModel(details: playlistVM.songsDict[index], cityId: playlistVM.cityId))
//                                            .listRowBackground(Color.background)
//                                    } else if index == 1 {
//                                        PodiumCell(songVM: SongDetailViewModel(details: playlistVM.songsDict[index], cityId: playlistVM.cityId))
//                                            .listRowBackground(Color.background)
//                                    } else if index == 2 {
//                                        PodiumCell(songVM: SongDetailViewModel(details: playlistVM.songsDict[index], cityId: playlistVM.cityId))
//                                            .listRowBackground(Color.background)
//                                    } else {
//                                        PlaylistCell(songVM: SongDetailViewModel(details: playlistVM.songsDict[index], cityId: playlistVM.cityId))
//                                            .listRowBackground(Color.background)
//                                    }
//                                }
                                
                            }
                            
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
                    SongSearchController()
                }

            }
        }
    }
}

struct CityPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        CityPlaylist()
    }
}
