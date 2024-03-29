//
//  CityPlaylist.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct CityPlaylist: View {
    @ObservedObject var playlistVM: PlaylistViewModel
    @EnvironmentObject var coordinator: RootCoordinator
    @Environment(\.openURL) private var openURL
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.background
                
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        RemoteImage(playlistVM.city?.image, placeholder: Image("placeholder"))
                            .frame(height: 200)

                        HStack {
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
                            Spacer()
                            Button {
                                if let url = URL(string: "spotify:playlist:\(self.playlistVM.city?.spotifyURI ?? "")"), UIApplication.shared.canOpenURL(url) {
                                    openURL(url)
                                    
                                } else if let url = URL(string: "https://open.spotify.com/playlist/\(self.playlistVM.city?.spotifyURI ?? "")") {
                                    openURL(url)
                                }
                            } label: {
                                Image("Spotify")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                            .padding(8)
                            .conditional(playlistVM.city?.spotifyURI == nil) {
                                EmptyView()
                            }

                        }
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
                                    PlaylistCellCoordinatorView(song: entry , rank: index, coordinator: PlaylistCellCoordinator(entry: entry, parent: coordinator))
                                        .onTapGesture {
                                            withAnimation(Animation.easeIn(duration: 0.2)) {
                                                playlistVM.setDetails(entry)
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
                .edgesIgnoringSafeArea([.top])

                SearchButton(width: 45, height: 45) {
                    playlistVM.showSearch()
                }
                .position(x: geo.size.width - 45, y: geo.size.height - 45)
        }.onAppear {
            playlistVM.fetch()
        }
        .environmentObject(playlistVM)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let hometownId = coordinator.userViewModel.user?.hometown?.hometownId, hometownId == playlistVM.city?.id ?? -1 {
                    EmptyView()
                } else {
                    Button {
                        guard let id = playlistVM.city?.id else { return }
                        coordinator.userViewModel.setHometown(id: id)
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.accent)
                                .frame(width: 30, height: 30)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                            Image("AddHometown")
                                .foregroundColor(.fontAlwaysLight)
                        }
                    }
                }

            }
        }
    }
}
}

struct CityPlaylist_Previews: PreviewProvider {
    static var city = City(country: "France", iso2: "FR", name: "Strasbourg", population: 123456, spotifyURI: "")
    static var previews: some View {
        CityPlaylist(playlistVM: PlaylistViewModel(list: [], city: city , coordinator: PlaylistCoordinator(parent: RootCoordinator(), city: city))).environmentObject(RootCoordinator())
    }
}
