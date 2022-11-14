//
//  SpotifyListen.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 19/10/2022.
//

import SwiftUI

struct SpotifyListen: View {
    @Environment(\.openURL) private var openURL

    @State var canOpen: Bool = false
    let songID: String
    
    var body: some View {
        Button {
            if let url = URL(string:"spotify:track:\(songID)"), UIApplication.shared.canOpenURL(url) {
                openURL(url)
                
            } else if let url = URL(string: "https://open.spotify.com/track/\(songID)") {
                openURL(url)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.attentionGrabbing)
                    .frame(width: 160, height: 36, alignment: .center)
                HStack {
                    Image.spotifyIconWhite
                        .resizable()
                        .frame(maxWidth: 24, maxHeight: 24)
                    Text(canOpen ? "PLAY ON SPOTIFY" : "GET SPOTIFY FREE")
                        .foregroundColor(.fontAlwaysLight)
                        .font(Font.customFont(.openSans, size: 14))
                }
            }
        }
        .onAppear {
            canOpen = UIApplication.shared.canOpenURL(URL(string:"spotify:track:\(songID)")!)
        }
    }
}

struct SpotifyListen_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyListen(songID: "3YfS47QufnLDFA71FUsgCM")
    }
}
