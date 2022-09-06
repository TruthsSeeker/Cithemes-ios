//
//  SongSearchController.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/01/2022.
//

import SwiftUI

struct SongSearch: View {
    @ObservedObject var searchVM: SongSearchViewModel = SongSearchViewModel()
    @State private var detailsShown = false
    @State private var shownItem: PlaylistEntry?
    @FocusState var isSearchFocused: Bool
    @EnvironmentObject var coordinator: RootCoordinator
    
    var body: some View {
        ZStack(alignment: .top){
            Color.background
            GeometryReader { geo in
                ZStack {
                    VStack{
                        SearchBar(search: $searchVM.searchTerms, focus: _isSearchFocused, height: 45, buttonAction: {
                            searchVM.search()
                            isSearchFocused = false
                        })
                        if searchVM.results.isEmpty {
                            Image("search-arrow", bundle: nil)
                                .resizable()
                                .frame(maxHeight: geo.size.height/2)
                                .foregroundColor(Color.relief)
                            Text("Search for a song")
                                .font(.custom("RalewayDots-Regular", size: 48))
                                .foregroundColor(Color.relief)
                        } else {
                            List(searchVM.results) { result in
                                SongSearchResult(song: result)
                                    .listRowBackground(Color.background)
                                    .listRowInsets(EdgeInsets())
                                    .onTapGesture {
                                        withAnimation(Animation.easeIn(duration: 0.2)) {
                                            coordinator.detailedSong = PlaylistEntry(id: -1, songInfo: result, cityId: -1)
                                        }
                                    }
                                    .transition(.opacity)
                            }
                                .listStyle(PlainListStyle())
                                .onAppear {
                                    UITableView.appearance().separatorColor = .clear
                                    UITableView.appearance().keyboardDismissMode = .onDrag
                                }
                        }
                        
                    }
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                }
            }
            if let item = coordinator.detailedSong {
                SongDetails(coordinator: SongDetailCoordinator(entry: item, parent: coordinator))
                    .edgesIgnoringSafeArea(.bottom)
//                    .onTapGesture {
//                        withAnimation(Animation.easeIn(duration: 0.2)) {
//                            coordinator.detailedSong = nil
//                        }
//                    }
//                    .transition(.opacity)
            }
        }
        .background(Color.background)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
            }
        }
        
    }
}

struct SongSearchController_Previews: PreviewProvider {
    static var previews: some View {
        SongSearch()
    }
}
