//
//  SongSearchBar.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/01/2022.
//

import SwiftUI

struct SongSearchBar: View {
    @State var search: String
    let height: CGFloat
    var body: some View {
        HStack(alignment: .bottom, spacing: 4){
            VStack(alignment: .center, spacing: 6) {
                TextField("Search for songs", text: $search)
                Rectangle()
                    .frame(height: 1, alignment: .trailing)
                    .foregroundColor(Color("Relief", bundle: nil))
            }
            .padding(EdgeInsets(top: 4, leading: 16, bottom: 6, trailing: 0))
            
            
            SearchButton(width: height - 2, height: height - 2, action: {})
                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
        }
        .cornerRadius(30)
        .background(Color("Accent", bundle: nil).cornerRadius(30))
        
    }
}

struct SongSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchBar(search: "", height: 45)
    }
}
