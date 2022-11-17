//
//  SongSearchResult.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 24/01/2022.
//

import SwiftUI

struct SongSearchResult: View {
    let song: SongInfo
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 60, alignment: .center)
            .foregroundColor(Color.background)
            HStack(alignment: .top) {
                RemoteImage(song.cover, placeholder: Image("placeholder"))
                    .frame(width: 45, height: 45, alignment: .center)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(song.title ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.openSans, size: 14))
                        .foregroundColor(Color.fontMain)
                    Text(song.artist ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.customFont(.ralewayRegular, size: 10))
                        .foregroundColor(Color.fontSecondary)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            
            
        }
    }
}

struct SongSearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchResult(song: SongInfo.example)
    }
}
