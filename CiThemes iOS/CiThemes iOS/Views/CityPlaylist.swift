//
//  CityPlaylist.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 07/04/2022.
//

import SwiftUI

struct CityPlaylist: View {
    @ObservedObject var playlistVM: PlaylistViewModel
    @EnvironmentObject var coordinator: TabCoordinator

    @State var searchShown: Bool = false
    @State var detailedSong: PlaylistEntry?
        
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
                                    PlaylistCellCoordinatorView(song: entry , rank: index, coordinator: PlaylistCellCoordinator(entry: entry, parent: coordinator))
                                        .onTapGesture {
                                            withAnimation(Animation.easeIn(duration: 0.2)) {
                                                detailedSong = entry
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
                    SongDetails(detailsViewModel: SongDetailViewModel(entry: item, coordinator: SongDetailCoordinator(entry: item, parent: coordinator)))
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let hometownId = coordinator.userViewModel.user?.hometownId, hometownId == playlistVM.city?.id ?? -1 {
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

struct CityPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        CityPlaylist(playlistVM: PlaylistViewModel(list: [], city: City(country: "France", iso2: "FR", name: "Strasbourg", population: 123456)))
    }
}
