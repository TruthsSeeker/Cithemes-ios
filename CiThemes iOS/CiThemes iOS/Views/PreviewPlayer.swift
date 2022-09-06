//
//  PreviewPlayer.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 13/06/2022.
//

import SwiftUI

struct PreviewPlayer: View {
    @ObservedObject var player: PreviewPlayerViewModel
        
    var body: some View {
        HStack {
            Button {
                player.togglePlayback()
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.fontAlwaysLight)
                    Image(systemName: player.playing ? "pause.circle.fill" : "play.circle.fill" )
                        .resizable()
                        .frame(width: 32, height: 32)
                    .foregroundColor(.attentionGrabbing)
                }
            }
            .disabled(!player.isReady)
            Slider(value: $player.playbackProgress, in: player.getPlaybackRange()) { editing in
                if editing {
                    player.startSeeking()
                } else {
                    player.seek()
                }
            }
            .tint(.attentionGrabbing)
        }
        .onDisappear {
            player.stop()
        }
    }
}

struct PreviewPlayer_Previews: PreviewProvider {
    static var previews: some View {
        PreviewPlayer(player: PreviewPlayerViewModel(url: URL(string: "https://p.scdn.co/mp3-preview/b32de0a9656f5096a69d574420f20ac30e20b360?cid=8d495ed8eb47499b9dc23009da77b031")!))
    }
}
