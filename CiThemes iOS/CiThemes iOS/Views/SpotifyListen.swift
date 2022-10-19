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
    let link: URL
    
    var body: some View {
        Button {
            openURL(link)
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
            canOpen = UIApplication.shared.canOpenURL(link)
        }
    }
}

struct SpotifyListen_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyListen(link: URL(string: "https://open.spotify.com/track/3YfS47QufnLDFA71FUsgCM")!)
    }
}
