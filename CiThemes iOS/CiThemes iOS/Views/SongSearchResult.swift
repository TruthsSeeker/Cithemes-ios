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
                RemoteImage(song.albumCoverURL, placeholder: Image("LosAngeles"))
                    .frame(width: 45, height: 45, alignment: .center)
                    .cornerRadius(8)
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
                
                
                VStack {
                    Text(String(song.score))
                        .frame(height: 45)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            
            
        }
    }
}

struct SongSearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchResult(song: SongInfo(id: "1", title: "Under the Bridge", artist: "Red Hot Chili Peppers", album: "Blood Sugar Sex Magik", score: 0, release: "1991", duration: "4:43", originalSuggestion: "Me", spotifyURI: URL(string: "www.example.com"), albumCoverURL: URL(string: "https://en.wikipedia.org/wiki/Blood_Sugar_Sex_Magik#/media/File:RHCP-BSSM.jpg")))
    }
}
