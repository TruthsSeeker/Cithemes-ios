//
//  SongSearch.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 07/09/2022.
//

import SwiftUI

struct SongSearch: View {
    @FocusState var isSearchFocused: Bool
    @ObservedObject var searchVM: SongSearchViewModel
    var body: some View {
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
                                        searchVM.setDetails(for: PlaylistEntry(id: -1, songInfo: result, cityId: searchVM.city.id ?? -1))
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

        .background(Color.background)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
            }
        }
    }
}

struct SongSearch_Previews: PreviewProvider {
    static var city = City(country: "France", iso2: "FR", name: "Strasbour", population: 123456)
    static var previews: some View {
        SongSearch(searchVM: SongSearchViewModel(city: city, coordinator: PlaylistCoordinator(parent: RootCoordinator(), city: city)))
    }
}
