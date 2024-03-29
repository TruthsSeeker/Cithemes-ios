//
//  CitySearch.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 10/05/2022.
//

import SwiftUI
import Introspect

struct CitySearch: View {
    @EnvironmentObject var coordinator: RootCoordinator
    @StateObject var searchVM: CitySearchViewModel = CitySearchViewModel()
    @State private var detailsShown = false
    @State private var nav: UINavigationController?
    @FocusState var searchFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top){
                Color.background
                GeometryReader { geo in
                    ZStack {
                        VStack{
                            SearchBar(search: $searchVM.searchTerms, focus: _searchFieldFocused, height: 45, buttonAction: {
                                searchVM.searchByName()
                                searchFieldFocused = false
                            })
                            ZStack {
                                if searchVM.results.isEmpty {
                                    VStack {
                                        Image("search-arrow", bundle: nil)
                                            .resizable()
                                            .frame(maxHeight: geo.size.height/2)
                                        .foregroundColor(Color.relief)
                                        Text("Search for a city")
                                            .font(.custom("RalewayDots-Regular", size: 48))
                                            .foregroundColor(Color.relief)
                                    }
                                } else {
                                    ScrollView {
                                        LazyVStack {
                                            ForEach(searchVM.results) { result in
                                                NavigationLink(destination: {
                                                    CityPlaylistCoordinatorView(coordinator: PlaylistCoordinator(parent: coordinator, city: result))
                                                }, label: {
                                                    CitySearchResult(city: result)
                                                })
                                                .listRowBackground(Color.background)
                                                .listRowInsets(EdgeInsets())
                                                
                                            }
                                        }
                                        
                                    }
//                                    .listStyle(PlainListStyle())
//                                    .onAppear {
//                                        UITableView.appearance().separatorColor = .clear
//                                        UITableView.appearance().keyboardDismissMode = .onDrag
//                                        UITableView.appearance().backgroundColor = .background
//                                    }
                                }
                                
                                LocationButton { location in
                                    searchVM.findNearest(withLocation: location)
                                }
                                .position(x: geo.size.width - 37, y: 30)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                    }
                }
            }
            .background(Color.background)
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
        .tint(.fontAlwaysLight)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchFieldFocused = true
            }
        }
        
    }
}

struct CitySearch_Previews: PreviewProvider {
    static var previews: some View {
        CitySearch().environmentObject(RootCoordinator())
    }
}
