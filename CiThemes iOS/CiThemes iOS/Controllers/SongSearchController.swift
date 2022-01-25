//
//  SongSearchController.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/01/2022.
//

import SwiftUI

struct SongSearchController: View {
    @StateObject var searchVM: SongSearchViewModel = SongSearchViewModel()
    var body: some View {
        ZStack(alignment: .top){
            Color.background
            GeometryReader { geo in
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
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            }
        }
        
    }
}

struct SongSearchController_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchController()
    }
}
