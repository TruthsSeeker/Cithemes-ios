//
//  SongDetailViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import Foundation
import Combine

final class SongDetailViewModel: ObservableObject {
    @Published var details: SongInfo?
    @Published var loading: Bool = false
    
    func fetch() {
        loading = true
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            self?.loading = false
            self?.details = SongInfo(id: self?.details?.id ?? "", title: self?.details?.title, artist: self?.details?.artist, album: "Blood Sugar Sex Magik", score: self?.details?.score ?? 0, release: "1991", duration: 283000, preview: nil, originalSuggestion: nil, spotifyURI: nil, albumCoverURL: nil)
        }
        #else
        #endif
    }
}
