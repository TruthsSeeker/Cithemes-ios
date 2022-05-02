//
//  SongSearchController.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/01/2022.
//

import SwiftUI

struct SongSearch: View {
    @StateObject var searchVM: SongSearchViewModel = SongSearchViewModel()
    @State private var detailsShown = false
    @State private var shownItem: SongInfo?
    
    var body: some View {
        ZStack(alignment: .top){
            Color.background
            GeometryReader { geo in
                ZStack {
                    VStack{
                        SearchBar(search: $searchVM.searchTerms, height: 45, buttonAction: {searchVM.search()})
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
                                            shownItem = result
                                        }
                                    }
                                    .transition(.opacity)
                            }
                                .listStyle(PlainListStyle())
                                .onAppear {
                                    UITableView.appearance().separatorColor = .clear
                                }
                        }
                        
                    }
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                }
            }
            if let item = shownItem {
                SongDetails(details: item)
                    .edgesIgnoringSafeArea(.bottom)
                    .onTapGesture {
                        withAnimation(Animation.easeIn(duration: 0.2)) {
                            shownItem = nil
                        }
                    }
                    .transition(.opacity)
            }
        }
        .background(Color.background)
        
    }
}

struct SongSearchController_Previews: PreviewProvider {
    static var previews: some View {
        SongSearch()
    }
}
