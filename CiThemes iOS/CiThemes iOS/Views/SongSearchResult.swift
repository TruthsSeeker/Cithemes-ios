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
        ZStack {
            Rectangle()
                .frame(height: 60, alignment: .center)
            .foregroundColor(Color.background)
            HStack {
                RemoteImage(song.albumCoverURL, placeholder: Image("LosAngeles"))
            }
        }
    }
}

struct SongSearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchResult(song: SongInfo(id: "1", title: "Under the Bridge", artist: "Red Hot Chili Peppers", album: "Blood Sugar Sex Magik", score: 0, release: "1991", duration: "4:43", originalSuggestion: "Me", spotifyURI: URL(string: "www.example.com"), albumCoverURL: URL(string: "https://en.wikipedia.org/wiki/Blood_Sugar_Sex_Magik#/media/File:RHCP-BSSM.jpg")))
    }
}
